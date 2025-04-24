import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';

class AnaliseComponent extends StatelessWidget {
  final CondominioModel condominio;

  const AnaliseComponent({super.key, required this.condominio});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Análise de Níveis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),

                    // Placeholder for chart
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Gráfico de Análise",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Placeholder for stats or additional info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          "Mínimo",
                          "${condominio.nivelReservatorioPercentual!}%",
                        ),
                        _buildStatItem(
                          "Médio",
                          "${condominio.nivelReservatorioPercentual}%",
                        ),
                        _buildStatItem(
                          "Máximo",
                          "${condominio.nivelReservatorioPercentual!}%",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Additional analysis card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tendências de Consumo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Content for trends
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
