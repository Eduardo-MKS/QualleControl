import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.5.97:5001';

  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Login response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<UserModel?> getUserInfo(String token) async {
    try {
      // Imprimir o token para verificação
      print('Token sendo usado: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/info'),
        headers: {
          'Content-Type': 'application/json',
          // Remover "Bearer " - baseado na captura de tela, apenas o token é necessário
          'Authorization': token,
        },
      );

      print('GetUserInfo response code: ${response.statusCode}');
      print('GetUserInfo response body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        try {
          final data = jsonDecode(response.body);
          print('GetUserInfo JSON decoded: $data');
          return UserModel.fromJson(data);
        } catch (parseError) {
          print('Error parsing user info: $parseError');
          print('Response body: ${response.body}');
          return null;
        }
      } else {
        print(
          'Get user info failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Get user info error: $e');
      return null;
    }
  }

  Future<List<String>?> getAvailableSystems(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/qualle'),
        headers: {
          'Content-Type': 'application/json',
          // Remover "Bearer " aqui também
          'Authorization': token,
        },
      );

      print('GetAvailableSystems response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<String>();
      } else {
        print('Get systems failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Get systems error: $e');
      return null;
    }
  }

  // Método para obter lista de condomínios disponíveis
  Future<List<String>?> getAvailableCondominios(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/qualle/condos'),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      print('GetAvailableCondominios response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<String>();
      } else {
        print(
          'Get condominios failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Get condominios error: $e');
      return null;
    }
  }
}
