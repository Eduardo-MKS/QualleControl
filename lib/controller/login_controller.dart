import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../service/api_service.dart';

class LoginController extends ChangeNotifier {
  final ValueNotifier<bool> inLoader = ValueNotifier<bool>(false);
  final ApiService _apiService = ApiService();

  String _login = '';
  String _senha = '';
  bool _keepConnected = false;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  void setLogin(String value) {
    _login = value;
    // Limpar erro quando usuário começar a digitar
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setSenha(String value) {
    _senha = value;
    // Limpar erro quando usuário começar a digitar
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setKeepConnected(bool value) => _keepConnected = value;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> auth() async {
    // VALIDAÇÃO OBRIGATÓRIA: Verificar se login e senha foram fornecidos
    if (_login.trim().isEmpty || _senha.trim().isEmpty) {
      _errorMessage = 'Login e senha são obrigatórios';
      notifyListeners(); // IMPORTANTE: notificar listeners
      return false;
    }

    inLoader.value = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _apiService.login(_login, _senha);

      if (token != null && token.isNotEmpty) {
        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);

        // Save keep connected preference
        await prefs.setBool('keep_connected', _keepConnected);

        // Get user info - SEMPRE tentar obter do servidor primeiro
        final userInfo = await _apiService.getUserInfo(token);

        if (userInfo != null) {
          _currentUser = userInfo;
          notifyListeners();

          // Store user info if keep connected is true
          if (_keepConnected) {
            await prefs.setString('user_info', jsonEncode(userInfo.toJson()));
          }

          return true;
        } else {
          // FALLBACK: Apenas se o servidor não retornar dados do usuário
          try {
            final jwtUser = _extractUserFromJWT(token);
            if (jwtUser != null) {
              _currentUser = jwtUser;
              notifyListeners();

              if (_keepConnected) {
                await prefs.setString(
                  'user_info',
                  jsonEncode(_currentUser!.toJson()),
                );
              }

              return true;
            } else {
              _errorMessage = 'Não foi possível obter informações do usuário';
              await _clearStoredData();
              notifyListeners();
              return false;
            }
          } catch (e) {
            _errorMessage = 'Erro ao processar token de autenticação';
            await _clearStoredData();
            notifyListeners();
            return false;
          }
        }
      } else {
        _errorMessage = 'Credenciais inválidas';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão. Tente novamente.';
      notifyListeners();
      print('Login error: $e');
      return false;
    } finally {
      inLoader.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // LIMPAR TODOS OS DADOS SALVOS - FORÇAR REMOÇÃO
      await prefs.remove('access_token');
      await prefs.remove('user_info');
      await prefs.remove('keep_connected');

      // ALTERNATIVA: Limpar TODAS as chaves relacionadas ao app (se necessário)
      // await prefs.clear(); // Use apenas se não houver outros dados importantes

      // LIMPAR COMPLETAMENTE O ESTADO DA MEMÓRIA
      _currentUser = null;
      _errorMessage = null;
      _login = '';
      _senha = '';
      _keepConnected = false;

      print('Logout realizado - dados removidos do SharedPreferences');

    } catch (e) {
      print('Erro ao fazer logout: $e');
      // Mesmo com erro, limpar o estado da memória
      _currentUser = null;
      _errorMessage = null;
      _login = '';
      _senha = '';
      _keepConnected = false;
    }

    notifyListeners();
  }

  Future<bool> checkLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final keepConnected = prefs.getBool('keep_connected') ?? false;

      // SEM TOKEN = SEM ACESSO
      if (token == null || token.isEmpty) {
        _currentUser = null;
        notifyListeners();
        return false;
      }

      // VALIDAR TOKEN SEMPRE - independente do keepConnected
      final userInfo = await _apiService.getUserInfo(token);

      if (userInfo != null) {
        // Token válido - usuário autenticado
        _currentUser = userInfo;

        // Atualizar dados locais se keepConnected estiver ativo
        if (keepConnected) {
          await prefs.setString('user_info', jsonEncode(userInfo.toJson()));
        }

        notifyListeners();
        return true;
      } else {
        // Token inválido/expirado
        if (keepConnected) {
          // Tentar usar dados locais APENAS como fallback temporário
          final storedUserInfo = prefs.getString('user_info');
          if (storedUserInfo != null) {
            try {
              _currentUser = UserModel.fromJson(jsonDecode(storedUserInfo));

              // Marcar que precisa revalidar na próxima oportunidade
              _errorMessage = 'Sessão expirada. Reconecte-se quando possível.';
              notifyListeners();

              return true; // Permite acesso offline limitado
            } catch (e) {
              await logout();
              return false;
            }
          }
        }

        // Limpar dados inválidos
        await logout();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao verificar autenticação';

      // Em caso de erro de rede, permitir acesso offline apenas se keepConnected
      final prefs = await SharedPreferences.getInstance();
      final keepConnected = prefs.getBool('keep_connected') ?? false;

      if (keepConnected) {
        final storedUserInfo = prefs.getString('user_info');
        if (storedUserInfo != null) {
          try {
            _currentUser = UserModel.fromJson(jsonDecode(storedUserInfo));
            notifyListeners();
            return true;
          } catch (e) {
            await logout();
            return false;
          }
        }
      }

      // Se não há dados salvos ou keepConnected é false, fazer logout
      await logout();
      return false;
    }
  }

  // Método auxiliar para extrair usuário do JWT
  UserModel? _extractUserFromJWT(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      String payload = parts[1];
      // Adicionar padding se necessário
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      // Decodificar
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final decodedJson = jsonDecode(decoded);

      // Verificar se o token não está expirado
      if (decodedJson.containsKey('exp')) {
        final exp = decodedJson['exp'] as int;
        final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (currentTime >= exp) {
          return null; // Token expirado
        }
      }

      return UserModel.fromJson(decodedJson);
    } catch (e) {
      return null;
    }
  }

  // Método auxiliar para limpar dados armazenados
  Future<void> _clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_info');
    await prefs.remove('keep_connected');
  }

  bool hasAccessTo(String system) {
    if (_currentUser == null || _currentUser!.role == null) {
      return false;
    }

    // Check if user has access to the specified system
    switch (system) {
      case 'azas':
        return _currentUser!.role!.containsKey('qualle-barragens');
      case 'condominios':
        return _currentUser!.role!.containsKey('qualle-condominio');
      case 'hidrometeorologia':
        return _currentUser!.role!.containsKey('qualle-meteorologia');
      case 'saneamento':
        return _currentUser!.role!.containsKey('qualle-saneamento');
      default:
        return false;
    }
  }

  // Método para forçar revalidação do token
  Future<bool> revalidateSession() async {
    if (_currentUser == null) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token != null) {
        final userInfo = await _apiService.getUserInfo(token);
        if (userInfo != null) {
          _currentUser = userInfo;
          _errorMessage = null;
          notifyListeners();
          return true;
        }
      }

      await logout();
      return false;
    } catch (e) {
      return false;
    }
  }

  // Método para limpar campos de entrada (útil para quando voltar à tela de login)
  void clearInputFields() {
    _login = '';
    _senha = '';
    _keepConnected = false;
    _errorMessage = null;
    notifyListeners();
  }
}