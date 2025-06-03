import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/pressao_chart.dart';

class PressaoCard extends StatelessWidget {
  final String titulo;
  final String cisterna;
  final Color color;
  final List<Map<String, dynamic>> historicoData;

  const PressaoCard({
    super.key,
    required this.titulo,
    required this.cisterna,
    required this.historicoData,
    this.color = const Color.fromARGB(255, 0, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    // Converter para valor inteiro
    final int pressaoValue = int.tryParse(cisterna.split('.').first) ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  "${pressaoValue}mca",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Gráfico de pressão
            PressaoChart(historicoData: historicoData),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
