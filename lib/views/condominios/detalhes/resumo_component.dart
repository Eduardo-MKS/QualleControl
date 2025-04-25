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
        condominio.nivelReservatorioMetros != null;

    final bool hasCisterna =
        condominio.hasCisterna &&
        (condominio.nivelCisternaPercentual != null ||
            condominio.nivelCisternaMetros != null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
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
}
