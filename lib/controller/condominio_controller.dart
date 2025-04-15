import 'package:flutter/material.dart';
import '../models/condominio_model.dart';

class CondominioController {
  // Lista de dados dos condomínios
  final List<CondominioModel> condominios = [
    CondominioModel(
      nome: "Edifício Missouri",
      nivelReservatorioPercentual: 56.55,
      nivelReservatorioMetros: 0.97,
      ultimaAtualizacao: DateTime.now(),
      imageCondo: "assets/prédios_Prancheta.png",
    ),
    CondominioModel(
      nome: "Condomínio Quinta das Palmeiras",
      nivelReservatorioPercentual: 0, // Not showing reservoir for this property
      nivelReservatorioMetros: 0,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(hours: 1)),
      imageCondo: "assets/casas.png",
      hasCisterna: true,
      nivelCisternaPercentual: 85.16,
      nivelCisternaMetros: 1.70,
      hasPressao: true,
      pressaoSaida: 116.2,
    ),
    CondominioModel(
      nome: "Edifício Tailândia",
      nivelReservatorioPercentual: 45.20,
      nivelReservatorioMetros: 0.82,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(minutes: 30)),
      imageCondo: "assets/prédios_Prancheta.png",
      hasPressao: true,
      pressaoSaida: 92.5,
    ),
    CondominioModel(
      nome: "Prefeitura Blumenau",
      nivelReservatorioPercentual: 78.10,
      nivelReservatorioMetros: 1.48,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(hours: 2)),
      imageCondo: "assets/prédios_Prancheta.png",
      hasCisterna: true,
      nivelCisternaPercentual: 62.30,
      nivelCisternaMetros: 1.25,
    ),
    CondominioModel(
      nome: "Edifício WZ Home Park",
      nivelReservatorioPercentual: 32.75,
      nivelReservatorioMetros: 0.68,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(minutes: 45)),
      imageCondo: "assets/prédios_Prancheta.png",
    ),
  ];

  void navegarParaDetalhes(BuildContext context, CondominioModel condominio) {
    Navigator.pushNamed(context, '/condominio-detalhes', arguments: condominio);
  }
}
