import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/condominios/components/reservatorio_chart.dart';

class PressaoCard extends StatelessWidget {
  final String titulo;
  final String cisterna;
  final Color color;

  const PressaoCard({
    super.key,
    required this.titulo,
    required this.cisterna,
    this.color = const Color.fromARGB(255, 0, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  cisterna,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 140,
              child: ReservatorioChart(nivelPercentual: 70),
            ),

            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
