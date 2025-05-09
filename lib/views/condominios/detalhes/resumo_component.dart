import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_gerais_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/cisterna_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/reservatorio_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/vazao_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/pressao_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/painel_reservatorio_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/painel_cisterna_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/casa_bombas_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/bombas_card.dart';

class ResumoScreen extends StatelessWidget {
  final CondominioModel condominio;
  const ResumoScreen({super.key, required this.condominio});

  @override
  Widget build(BuildContext context) {
    // Verificar se deve mostrar tanto reservatório quanto cisterna
    final bool hasReservatorio =
        condominio.nivelReservatorioPercentual != null ||
        (condominio.nivelReservatorioMetros != null &&
            condominio.nivelReservatorioMetros!.isNotEmpty);

    final bool hasCisterna =
        condominio.hasCisterna &&
        (condominio.nivelCisternaPercentual != null ||
            (condominio.pressaoSaida != null &&
                condominio.totalizador != null) ||
            (condominio.nivelCisternaMetros != null &&
                condominio.nivelCisternaMetros!.isNotEmpty));

    // Verificar se pressão de saída tem um valor válido e não-zero
    final bool hasPressaoSaida =
        condominio.pressaoSaida != null &&
        condominio.pressaoSaida != "0.0" &&
        condominio.pressaoSaida != "0";

    final bool hasVazao =
        condominio.vazao != null || condominio.totalizador != null;

    bool shouldShowCasaDeBombas = condominio.hasCasaDeBombas;

    bool shouldShowInfosGerais = condominio.hasGeral;

    List<String> excludedCondominiosForCasaDeBombas = [
      'Condomínio Quinta Das Palmeiras',
      'Parque Vila Germânica',
    ];

    List<String> excludedCondominiosForInfosGerais = ['Edifício Tailândia'];

    if (excludedCondominiosForCasaDeBombas.contains(condominio.nome)) {
      shouldShowCasaDeBombas = false;
    }

    if (excludedCondominiosForInfosGerais.contains(condominio.nome)) {
      shouldShowInfosGerais = false;
    }

    final bool hasGeral = shouldShowInfosGerais && condominio.hasGeral;

    final bool hasCasaDeBombas =
        shouldShowCasaDeBombas &&
        (condominio.energia == 'true' ||
            condominio.operacao == 'true' ||
            condominio.rodizio == 'true' ||
            condominio.porta == 'true' ||
            (condominio.bombas?.any((b) => b['bombaLigada'] == true) ?? false));

    // Verificar se há informações de bombas disponíveis
    final bool hasBombas =
        condominio.bombas != null &&
        condominio.bombas!.isNotEmpty &&
        condominio.hasCasaDeBombas;

    // Obter histórico de dados se disponível
    List<Map<String, dynamic>> historicoData = [];
    if (condominio.historico != null) {
      historicoData = List<Map<String, dynamic>>.from(condominio.historico!);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (hasCasaDeBombas)
              CasaBombasCard(
                titulo: "Painel Casa de Bombas",
                condominio: condominio,
                energia: condominio.energia ?? 'false',
                operacao: condominio.operacao ?? 'false',
                rodizio: condominio.rodizio ?? 'false',
                porta: condominio.porta ?? 'false',
              ),

            if (hasBombas) BombasCard(titulo: "Bombas", condominio: condominio),

            if (condominio.hasPainelReservatorio)
              PainelReservatorioCard(
                titulo: "Painel Reservatório",
                condominio: condominio,
                painelBateria:
                    condominio.painelBateria ?? condominio.bateria ?? '14.14',
                bateria:
                    condominio.painelBateria ?? condominio.bateria ?? '14.14V',
              ),

            if (condominio.hasPainelCisterna)
              PainelCisternaCard(
                titulo: "Painel Cisterna",
                condominio: condominio,
                bateria: condominio.painelCisternaBateria ?? '14.14V',
              ),

            if (hasGeral)
              InfoGeraisCard(
                titulo: "Informações Gerais",
                condominio: condominio,
                operacao: '${condominio.operacao}',
                energia: '${condominio.energia}',
                boia: '${condominio.boia}',
                bateria: '${condominio.bateria}',
              ),

            if (hasVazao)
              VazaoCard(
                titulo: "Vazão (m³/h)",
                vazaoValue: condominio.vazao ?? "0.0",
                totalizadorValue: condominio.totalizador ?? "0.0",
                historicoData: historicoData,
              )
            else
              const SizedBox(height: 12),

            if (hasReservatorio)
              ReservatorioCard(
                titulo: "Reservatório",
                percentualValue: condominio.nivelReservatorioPercentual ?? 0.0,
                metrosValue: "${condominio.nivelReservatorioMetros ?? 'N/A'}m",
                nivelVolumeReservatorio:
                    condominio.nivelVolumeReservatorio ?? '0.0',
                historicoData: historicoData,
              ),

            if (hasReservatorio && hasCisterna) const SizedBox(height: 12),

            if (hasCisterna)
              CisternaCard(
                titulo: "Cisterna",
                percentualValue: condominio.nivelCisternaPercentual ?? 0.0,
                metrosValue: "${condominio.nivelCisternaMetros ?? 'N/A'}m",
                nivelVolume: condominio.nivelVolume ?? '0.0',
                historicoData: historicoData,
              ),

            if (hasCisterna) const SizedBox(height: 16),

            if (hasCisterna && hasPressaoSaida)
              PressaoCard(
                titulo: "Pressão Saída",
                cisterna: condominio.pressaoSaida ?? "0.0",
                historicoData: historicoData,
              ),
          ],
        ),
      ),
    );
  }
}
