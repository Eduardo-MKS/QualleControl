import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/vazao_chart.dart';

class VazaoCard extends StatelessWidget {
  final String titulo;
  final String vazaoValue;
  final String totalizadorValue;
  final Color color;
  final List<Map<String, dynamic>> historicoData;

  const VazaoCard({
    super.key,
    required this.titulo,
    required this.vazaoValue,
    required this.totalizadorValue,
    this.color = const Color.fromARGB(255, 31, 31, 31),
    required this.historicoData,
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
                  vazaoValue,
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

            VazaoChart(historicoData: historicoData),

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
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "0.36",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Gráfico de pressão
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 65.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Totalizador (m³)",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14,
                          ),
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
