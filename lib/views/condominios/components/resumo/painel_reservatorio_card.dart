import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_row.dart';

class PainelReservatorioCard extends StatelessWidget {
  final String titulo;
  final String bateria;
  final CondominioModel condominio;

  const PainelReservatorioCard({
    super.key,
    required this.titulo,
    required this.bateria,
    required this.condominio,
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
            Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: Color.fromARGB(255, 0, 0, 0)),
            const SizedBox(height: 8),

            // Energia 220V - Pega da API
            if (condominio.painelEnergia != null)
              InfoRow(
                label: "Energia 220V",
                value: condominio.painelEnergia == true ? "Normal" : "Falta",
                statusColor:
                    condominio.painelEnergia == true
                        ? Colors.green
                        : Colors.red,
              ),

            InfoRow(label: "Porta", value: "Fechada", statusColor: null),

            // LED - Pega da API se disponível
            if (condominio.painelLed != null)
              InfoRow(
                label: "LED",
                value: condominio.painelLed == true ? "Desligado" : "Normal",
                statusColor:
                    condominio.painelLed == true
                        ? const Color.fromARGB(255, 233, 33, 33)
                        : const Color.fromARGB(255, 60, 185, 35),
              ),

            // Sirene - Pega da API se disponível
            if (condominio.painelSirene != null)
              InfoRow(
                label: "Sirene",
                value: condominio.painelSirene == true ? "Desligada" : "Normal",
                statusColor:
                    condominio.painelSirene == true
                        ? Colors.red
                        : const Color.fromARGB(255, 53, 215, 21),
              ),
            // Bateria
            InfoRow(label: "Bateria", value: bateria, statusColor: null),
          ],
        ),
      ),
    );
  }
}
