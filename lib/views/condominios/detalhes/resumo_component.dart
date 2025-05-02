import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_gerais_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/reservatorio_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/vazao_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/pressao_card.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/painel_reservatorio_card.dart';

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

    // Verificar se deve mostrar as informações gerais
    final bool hasGeral = condominio.hasGeral && hasPressaoSaida;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Card de Painel Reservatório (só mostrar se hasPainelReservatorio for true)
            if (condominio.hasPainelReservatorio)
              PainelReservatorioCard(
                titulo: "Painel Reservatório",
                condominio: condominio,
                bateria:
                    condominio.painelBateria ?? condominio.bateria ?? 'N/A',
              ),

            // Card de Informações Gerais (se tiver dados)
            if (hasGeral)
              InfoGeraisCard(
                titulo: "Informações Gerais",
                condominio: condominio,
                operacao: '${condominio.operacao}',
                energia: '${condominio.energia}',
                boia: '${condominio.boia}',
                bateria: '${condominio.bateria}',
              ),

            // Card de Vazão (se tiver dados)
            if (hasVazao)
              VazaoCard(
                titulo: "Vazão (m³/h)",
                vazaoValue: condominio.vazao ?? "0.0",
                totalizadorValue: condominio.totalizador ?? "0.0",
              )
            else
              const SizedBox(height: 12),

            if (hasGeral && (hasReservatorio || hasCisterna))
              const SizedBox(height: 12),

            // Card do Reservatório (se tiver dados)
            if (hasReservatorio)
              ReservatorioCard(
                titulo: "Reservatório",
                percentualValue: condominio.nivelReservatorioPercentual ?? 0.0,
                metrosValue: "${condominio.nivelReservatorioMetros ?? 'N/A'}m",
              ),

            if (hasReservatorio && hasCisterna) const SizedBox(height: 12),

            // Card da Cisterna (se tiver dados)
            if (hasCisterna)
              ReservatorioCard(
                titulo: "Cisterna",
                percentualValue: condominio.nivelCisternaPercentual ?? 0.0,
                metrosValue: "${condominio.nivelCisternaMetros ?? 'N/A'}m",
              ),

            // Só mostrar o card de pressão de saída se tiver um valor válido e não-zero
            if (hasCisterna && hasPressaoSaida)
              PressaoCard(
                titulo: "Pressão de Saída mca",
                cisterna: condominio.pressaoSaida ?? "0.0",
              ),
          ],
        ),
      ),
    );
  }
}
