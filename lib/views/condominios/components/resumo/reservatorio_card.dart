import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/reservatorio_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class ReservatorioCard extends StatelessWidget {
  final String titulo;
  final double percentualValue;
  final String metrosValue;
  final String? nivelCisternaPercentual;
  final String? nivelVolumeReservatorio;
  final List<Map<String, dynamic>> historicoData;

  const ReservatorioCard({
    super.key,
    required this.titulo,
    required this.percentualValue,
    required this.metrosValue,
    required this.historicoData,
    this.nivelCisternaPercentual,
    this.nivelVolumeReservatorio,
  });

  @override
  Widget build(BuildContext context) {
    // Converter percentualValue para exibição em porcentagem
    final percentDisplay =
        (nivelCisternaPercentual != null
            ? double.parse(nivelCisternaPercentual! * 100).toStringAsFixed(2)
            : null) ??
        '${(percentualValue * 100).toStringAsFixed(2)}%';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$percentDisplay ",
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),

            // Adiciona o gráfico de histórico apenas se tivermos dados históricos
            ReservatorioChart(historicoData: historicoData),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nível (m³)',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nivelVolumeReservatorio!,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Nível (m)',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      metrosValue,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
