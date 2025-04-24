import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/reservatorio_chart.dart';

class ResumoScreen extends StatelessWidget {
  final CondominioModel condominio;
  const ResumoScreen({super.key, required this.condominio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
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
                "Reservatório",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),
              const Divider(color: Colors.grey),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),

              // Gráfico do reservatório
              SizedBox(
                height: 180,
                child: ReservatorioChart(
                  nivelPercentual:
                      (condominio.nivelReservatorioPercentual ?? 0.0) * 100,
                ),
              ),

              const SizedBox(height: 20),

              // Informações de nível
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nível (%)",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${((condominio.nivelReservatorioPercentual ?? 0.0) * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 50, width: 1, color: Colors.grey),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nível (m)",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${condominio.nivelReservatorioMetros ?? 'N/A'}m", // Exibe 'N/A' se for nulo
                        style: const TextStyle(
                          fontSize: 18,
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
      ),
    );
  }
}
