import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_row.dart';

class InfoGeraisCard extends StatelessWidget {
  final String titulo;
  final CondominioModel condominio;
  final String energia;
  final String boia;
  final String bateria;
  final String operacao;

  const InfoGeraisCard({
    super.key,
    required this.titulo,
    required this.condominio,
    required this.energia,
    required this.boia,
    required this.bateria,
    required this.operacao,
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
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            // Energia 220V
            if (condominio.energia != null)
              InfoRow(
                label: "Energia 220V",
                value: condominio.energia == "true" ? "Normal" : "Falta",
                statusColor:
                    condominio.energia == "true" ? Colors.green : Colors.red,
              ),

            // Boia
            if (condominio.boia != null)
              InfoRow(
                label: "Boia",
                value: condominio.boia == "true" ? "Normal" : "Cheia",
                statusColor:
                    condominio.boia == "true" ? Colors.green : Colors.red,
              ),

            // Bateria
            if (condominio.bateria != null)
              InfoRow(
                label: "Bateria",
                value: "${condominio.bateria}V",
                statusColor: null,
              ),

            // Operação
            if (condominio.operacao != null)
              InfoRow(
                label: "Operação",
                value: condominio.operacao == "true" ? "Remota" : "Local",
                statusColor: null,
              ),
          ],
        ),
      ),
    );
  }
}
