// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/condominio_model.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class CondominioController extends ChangeNotifier {
  List<CondominioModel> _condominios = [];
  List<CondominioModel> get condominios => _condominios;

  final String baseUrl = 'http://10.0.0.34:5001';
  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Timer? _refreshTimer;
  bool _isInitialized = false;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CondominioController() {
    // Não carregar automaticamente no construtor
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    _isInitialized = true;
    await loadCondominios();

    // Configurar o timer apenas uma vez após a inicialização
    _refreshTimer?.cancel(); // Cancela qualquer timer existente
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      loadCondominios();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) {
      print('Token de autenticação não encontrado');
      _errorMessage = 'Usuário não autenticado';
    }
    return token;
  }

  Future<List<Map<String, dynamic>>> _getCondominiosData(String token) async {
    print('*** Buscando informações de condomínios ***');

    try {
      final url = '$baseUrl/qualle/condos/clients';

      final Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json', 'Authorization': token},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map &&
            data.containsKey('qualle-condominio') &&
            data['qualle-condominio'] is List) {
          final List<dynamic> condosList = data['qualle-condominio'];

          List<Map<String, dynamic>> result = [];
          for (var condo in condosList) {
            // Para cada condomínio, extraímos as estações
            if (condo is Map &&
                condo.containsKey('stations') &&
                condo['stations'] is List) {
              final List<dynamic> stations = condo['stations'];

              for (var station in stations) {
                if (station is Map) {
                  result.add({
                    'raw_name': condo['raw_name'],
                    'public_name': condo['public_name'],
                    'station_raw_name': station['raw_name'],
                    'station_public_name': station['public_name'],
                  });
                }
              }
            }
          }
          print('Total de estações encontradas: ${result.length}');
          return result;
        } else {
          print('Estrutura de dados inesperada: ${response.data}');
        }
      } else {
        print('Erro ao buscar condomínios: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar informações dos condomínios: $e');
      if (e is DioException) {
        print('Erro do Dio: ${e.message}');
        if (e.response != null) {
          print('Dados da resposta de erro do Dio: ${e.response!.data}');
        }
      }
    }

    return [];
  }

  Future<CondominioModel?> buscarCondominio(
    Map<String, dynamic> condoInfo,
    String token,
  ) async {
    print('*** Buscar Condomínio Agregado ***');

    final String rawName = condoInfo['raw_name'] ?? '';
    final String stationCode = condoInfo['station_raw_name'] ?? '';

    if (rawName.isEmpty) {
      print('raw_name não disponível para buscar dados agregados');
      return null;
    }

    final url =
        '$baseUrl/qualle/condos/aggregated-data/$rawName?stationCode=$stationCode';
    print('URL chamada: $url');

    try {
      final Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json', 'Authorization': token},
        ),
      );

      print('Status da resposta: ${response.statusCode}');
      print('Dados da resposta (resumo): ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        try {
          final dynamic data = response.data;
          if (data is List && data.isNotEmpty) {
            final condominio = CondominioModel.fromJson(data.first);
            print(
              'Condomínio (da lista) montado: ${condominio.nome}, Nível: ${condominio.nivelReservatorioPercentual}',
            );
            return condominio;
          } else if (data is Map<String, dynamic>) {
            final condominio = CondominioModel.fromJson(data);
            print(
              'Condomínio (do objeto) montado: ${condominio.nome}, Nível: ${condominio.nivelReservatorioPercentual}',
            );
            return condominio;
          } else {
            print(
              'Resposta da API em formato inesperado ou vazia para o condomínio: $rawName',
            );
          }
        } catch (e) {
          print('Erro ao decodificar o JSON para $rawName: $e');
          print('Dados da resposta com erro: ${response.data}');
        }
      } else {
        print('Erro ao buscar condomínio $rawName: ${response.statusCode}');
        print('Mensagem de erro da API: ${response.statusMessage}');
        _errorMessage = 'Falha ao carregar condomínio: ${response.statusCode}';
      }
    } catch (e) {
      print('Erro na requisição para $rawName: $e');
      _errorMessage = 'Erro de requisição: $e';
      if (e is DioException) {
        print('Erro do Dio: ${e.message}');
        if (e.response != null) {
          print('Dados da resposta de erro do Dio: ${e.response!.data}');
        }
      }
    }
    return null;
  }

  Future<void> loadCondominios() async {
    // Se já estiver carregando, não inicie outro carregamento
    if (_isLoading) return;

    print('*** Carregando Condomínios ***');
    _isLoading = true;
    _errorMessage = null;

    // Notificar apenas para atualizar o estado de carregamento
    notifyListeners();

    // Obter o token de autenticação
    final token = await _getAuthToken();
    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Primeiro, obter a lista completa de condomínios e suas estações
    final condosInfo = await _getCondominiosData(token);

    // Criar uma lista temporária para evitar atualizações parciais
    List<CondominioModel> tempCondominios = [];

    if (condosInfo.isNotEmpty) {
      // Para cada condomínio/estação, buscamos os dados agregados
      for (final condoInfo in condosInfo) {
        final condominio = await buscarCondominio(condoInfo, token);
        if (condominio != null) {
          tempCondominios.add(condominio);
          print(
            'Condomínio "${condominio.nome}" adicionado à lista temporária.',
          );
        }
      }
    } else {
      print('Nenhuma informação de condomínio disponível.');
      _errorMessage = 'Não foi possível obter a lista de condomínios.';
    }

    // Atualizar a lista principal apenas quando todos os dados estiverem carregados
    _condominios = tempCondominios;
    print('Lista de condomínios carregada. Total: ${_condominios.length}');

    _isLoading = false;

    // Notificar apenas uma vez após todos os dados estarem carregados
    notifyListeners();
  }

  void navegarParaDetalhes(BuildContext context, CondominioModel condominio) {
    Navigator.pushNamed(context, '/condominio-detalhes', arguments: condominio);
  }

  // Método para forçar uma atualização dos dados
  Future<void> refreshCondominios() async {
    await loadCondominios();
  }
}
