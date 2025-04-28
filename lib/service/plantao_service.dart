import 'package:dio/dio.dart';
import 'package:flutter_mks_app/models/plantao_model.dart';

class PlantaoService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://sobreaviso.mkssistemas.com.br';

  Future<PlantaoResponse?> getPlantaoAtual() async {
    try {
      final response = await _dio.get('$_baseUrl/sobreavisos/atual?json');
      if (response.statusCode == 200) {
        return PlantaoResponse.fromJson(response.data);
      } else {
        // ignore: avoid_print
        print('Erro ao buscar dados do plantão: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // ignore: avoid_print
      print('Erro na requisição do plantão: $error');
      return null;
    }
  }
}
