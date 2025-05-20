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

  void setLogin(String value) => _login = value;
  void setSenha(String value) => _senha = value;
  void setKeepConnected(bool value) => _keepConnected = value;

  Future<bool> auth() async {
    inLoader.value = true;

    try {
      final token = await _apiService.login(_login, _senha);

      if (token != null) {
        print('Token recebido após login: $token');

        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);

        // Save keep connected preference
        await prefs.setBool('keep_connected', _keepConnected);

        // Get user info
        final userInfo = await _apiService.getUserInfo(token);
        print('userInfo retornado: $userInfo');

        if (userInfo != null) {
          print('Usuário autenticado: ${userInfo.username}');
          _currentUser = userInfo;
          notifyListeners();

          // Store user info if keep connected is true
          if (_keepConnected) {
            await prefs.setString('user_info', jsonEncode(userInfo.toJson()));
          }

          return true;
        } else {
          // Tentativa de depuração: imprimir o token e tentar decodificá-lo
          print(
            'Não foi possível obter informações do usuário com o token: $token',
          );
          try {
            // Verificar se o token é JWT e tentar extrair informações dele
            final parts = token.split('.');
            if (parts.length == 3) {
              String payload = parts[1];
              // Adicionar padding se necessário
              while (payload.length % 4 != 0) {
                payload += '=';
              }
              // Decodificar
              final normalized = base64Url.normalize(payload);
              final decoded = utf8.decode(base64Url.decode(normalized));
              print('Token payload decoded: $decoded');

              // Criar usuário a partir do token JWT se o servidor não retornar
              final decodedJson = jsonDecode(decoded);
              _currentUser = UserModel.fromJson(decodedJson);
              notifyListeners();

              if (_keepConnected) {
                await prefs.setString(
                  'user_info',
                  jsonEncode(_currentUser!.toJson()),
                );
              }

              return true;
            }
          } catch (e) {
            print('Erro ao decodificar token: $e');
          }
        }
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      inLoader.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_info');
    await prefs.remove('keep_connected');
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> checkLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final keepConnected = prefs.getBool('keep_connected') ?? false;

      if (token != null) {
        print('Token encontrado no storage: $token');

        // If keep connected is false, validate token with server
        if (!keepConnected) {
          final userInfo = await _apiService.getUserInfo(token);
          if (userInfo != null) {
            _currentUser = userInfo;
            notifyListeners();
            return true;
          } else {
            // Se não conseguir obter informações do usuário, tentar decodificar o token
            try {
              // Verificar se o token é JWT e tentar extrair informações dele
              final parts = token.split('.');
              if (parts.length == 3) {
                String payload = parts[1];
                // Adicionar padding se necessário
                while (payload.length % 4 != 0) {
                  payload += '=';
                }
                // Decodificar
                final normalized = base64Url.normalize(payload);
                final decoded = utf8.decode(base64Url.decode(normalized));
                print('Token payload decoded: $decoded');

                // Criar usuário a partir do token JWT se o servidor não retornar
                final decodedJson = jsonDecode(decoded);
                _currentUser = UserModel.fromJson(decodedJson);
                notifyListeners();
                return true;
              }
            } catch (e) {
              print('Erro ao decodificar token: $e');
            }

            // If token is invalid, clean up
            await logout();
            return false;
          }
        } else {
          // If keep connected is true, try to load user from local storage
          final storedUserInfo = prefs.getString('user_info');
          if (storedUserInfo != null) {
            try {
              _currentUser = UserModel.fromJson(jsonDecode(storedUserInfo));
              notifyListeners();

              // Validate token in background
              _apiService.getUserInfo(token).then((userInfo) {
                if (userInfo == null) {
                  // Token expired, but don't logout immediately
                  // This allows offline access but will require login next time
                  prefs.remove('access_token');
                } else {
                  // Update stored user info with latest from server
                  _currentUser = userInfo;
                  prefs.setString('user_info', jsonEncode(userInfo.toJson()));
                  notifyListeners();
                }
              });

              return true;
            } catch (e) {
              print('Error decoding stored user info: $e');
              await logout();
              return false;
            }
          }
        }
      }

      return false;
    } catch (e) {
      print('Check login error: $e');
      return false;
    }
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
}
