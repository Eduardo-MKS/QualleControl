import 'package:flutter/material.dart';
import '../models/condominio_model.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class CondominioController extends ChangeNotifier {
  List<CondominioModel> _condominios = [];
  List<CondominioModel> get condominios => _condominios;
  final String baseUrl = 'http://10.0.0.34:5000/condos/';
  final Dio _dio = Dio();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Timer? _refreshTimer;
  bool _isInitialized = false;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Construtor sem carregamento automático
  CondominioController() {
    // Não carregar automaticamente no construtor
  }

  // Método para inicializar o controlador (chamado uma única vez)
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

  Future<CondominioModel?> buscarCondominio(String stationCode) async {
    print('*** Buscar Condomínio (com Dio) ***');
    print('URL chamada: ${baseUrl}?stationCode=$stationCode');
    try {
      final Response response = await _dio.get(
        '$baseUrl?stationCode=$stationCode',
      );

      print('Status da resposta: ${response.statusCode}');
      print('Dados da resposta (JSON): ${response.data}');

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
              'Resposta da API em formato inesperado ou vazia para o condomínio: $stationCode',
            );
          }
        } catch (e) {
          print('Erro ao decodificar o JSON para $stationCode: $e');
          print('Dados da resposta com erro: ${response.data}');
        }
      } else {
        print('Erro ao buscar condomínio $stationCode: ${response.statusCode}');
        print('Mensagem de erro da API: ${response.statusMessage}');
        _errorMessage = 'Falha ao carregar condomínio: ${response.statusCode}';
      }
    } catch (e) {
      print('Erro na requisição para $stationCode: $e');
      _errorMessage = 'Erro de requisição: $e';
      if (e is DioException) {
        print('Erro do Dio: ${e.message}');
        if (e.response != null) {
          print('Dados da resposta de erro do Dio: ${e.response!.data}');
          print('Headers da resposta de erro do Dio: ${e.response!.headers}');
        }
      }
    }
    return null;
  }

  Future<void> loadCondominios() async {
    // Se já estiver carregando, não inicie outro carregamento
    if (_isLoading) return;

    print('*** Carregar Condomínios (com Dio) ***');
    _isLoading = true;
    _errorMessage = null;

    // Notificar apenas para atualizar o estado de carregamento
    notifyListeners();

    // Criar uma lista temporária para evitar atualizações parciais
    List<CondominioModel> tempCondominios = [];

    for (int i = 0; i <= 7; i++) {
      final stationCode = 'cond0000$i';
      final condominio = await buscarCondominio(stationCode);
      if (condominio != null) {
        tempCondominios.add(condominio);
        print('Condomínio "${condominio.nome}" adicionado à lista temporária.');
      }
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
