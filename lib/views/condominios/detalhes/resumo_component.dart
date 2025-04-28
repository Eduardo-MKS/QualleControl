import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/reservatorio_chart.dart';

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
            (condominio.nivelCisternaMetros != null &&
                condominio.nivelCisternaMetros!.isNotEmpty));

    final bool hasVazao =
        condominio.vazao != null || condominio.totalizador != null;

    // Verificar se deve mostrar as informações gerais
    final bool hasGeral =
        condominio.energia != null ||
        condominio.boia != null ||
        condominio.bateria != null ||
        condominio.operacao != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Card de Informações Gerais (se tiver dados)
            if (hasGeral) _buildInfoGeraisCard(),

            // Card de Vazão (se tiver dados)
            if (hasVazao)
              _buildCardVazao(
                titulo: "Vazão",
                vazaoValue: condominio.vazao ?? "0.0",
                totalizadorValue: condominio.totalizador ?? "0.0",
                color: const Color.fromARGB(255, 66, 143, 68),
              )
            else
              const SizedBox(height: 12),

            if (hasGeral && (hasReservatorio || hasCisterna))
              const SizedBox(height: 12),

            // Card do Reservatório (se tiver dados)
            if (hasReservatorio)
              _buildCard(
                titulo: "Reservatório",
                percentualValue: condominio.nivelReservatorioPercentual ?? 0.0,
                metrosValue: "${condominio.nivelReservatorioMetros ?? 'N/A'}m",
                pressaoSaida:
                    condominio.hasPressao ? condominio.pressaoSaida : null,
                color: Colors.blue,
              ),

            if (hasReservatorio && hasCisterna) const SizedBox(height: 12),

            // Card da Cisterna (se tiver dados)
            if (hasCisterna)
              _buildCard(
                titulo: "Cisterna",
                percentualValue: condominio.nivelCisternaPercentual ?? 0.0,
                metrosValue: "${condominio.nivelCisternaMetros ?? 'N/A'}m",
                pressaoSaida:
                    null, // A cisterna geralmente não tem pressão de saída
                color: const Color.fromARGB(255, 6, 20, 124),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGeraisCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informações Gerais",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            // Energia 220V
            if (condominio.energia != null)
              _buildInfoRow(
                "Energia 220V",
                condominio.energia == "true" ? "Normal" : "Falta",
                condominio.energia == "true" ? Colors.green : Colors.red,
              ),

            // Boia
            if (condominio.boia != null)
              _buildInfoRow(
                "Boia",
                condominio.boia == "true" ? "Normal" : "Vazia",
                condominio.boia == "true" ? Colors.green : Colors.red,
              ),

            // Bateria
            if (condominio.bateria != null)
              _buildInfoRow("Bateria", "${condominio.bateria}V", null),

            // Operação
            if (condominio.operacao != null)
              _buildInfoRow(
                "Operação",
                condominio.operacao == "true" ? "Remota" : "Local",
                null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color? statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          if (statusColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String titulo,
    required double percentualValue,
    required String metrosValue,
    double? pressaoSaida,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                  ),
                ),
                Text(
                  "${(percentualValue * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            // Gráfico reduzido de tamanho
            SizedBox(
              height: 140,
              child: ReservatorioChart(nivelPercentual: percentualValue * 100),
            ),

            const SizedBox(height: 12),

            // Informações de nível
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nível (m³)",
                        style: TextStyle(color: color, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pressaoSaida != null
                            ? ((pressaoSaida * 100)).toStringAsFixed(1)
                            : "N/A",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: Colors.grey),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nível (m)",
                          style: TextStyle(color: color, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          metrosValue,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardVazao({
    required String titulo,
    required String vazaoValue,
    required String totalizadorValue,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vazão (l/s)",
                        style: TextStyle(color: color, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "teste",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: Colors.grey),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Totalizador (m³)",
                          style: TextStyle(color: color, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalizadorValue,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
