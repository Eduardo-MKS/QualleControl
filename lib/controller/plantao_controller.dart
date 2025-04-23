import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/plantao_model.dart';
import 'package:flutter_mks_app/service/plantao_service.dart';

class PlantaoController extends ChangeNotifier {
  final PlantaoService _plantaoService = PlantaoService();
  PlantaoAtual? _plantaoAtual;
  bool _isLoading = false;
  String? _errorMessage;

  PlantaoAtual? get plantaoAtual => _plantaoAtual;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PlantaoController() {
    _loadPlantaoData();
    // Agendar atualização para toda segunda-feira às 09:00 AM
    _scheduleWeeklyUpdate();
  }

  Future<void> _loadPlantaoData() async {
    _isLoading = true;
    notifyListeners();

    final response = await _plantaoService.getPlantaoAtual();
    if (response?.sobreavisoAtual != null) {
      _plantaoAtual = response?.sobreavisoAtual;
      _errorMessage = null;
    } else {
      _plantaoAtual = null;
      _errorMessage = 'Falha ao carregar os dados do plantão.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void _scheduleWeeklyUpdate() {
    // Calcula o tempo até a próxima segunda-feira às 09:00 AM
    DateTime now = DateTime.now();
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday < 0) {
      daysUntilMonday += 7;
    }
    DateTime nextMonday = DateTime(
      now.year,
      now.month,
      now.day + daysUntilMonday,
      9,
      0,
      0,
    );
    Duration difference = nextMonday.difference(now);

    // Executa a atualização após o tempo calculado
    Future.delayed(difference, () {
      _loadPlantaoData();
      // Agenda a próxima atualização para a próxima semana
      _scheduleWeeklyUpdate();
    });
  }
}
