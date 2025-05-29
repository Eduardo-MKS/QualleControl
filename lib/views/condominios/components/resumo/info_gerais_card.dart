import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_row.dart';
import 'package:google_fonts/google_fonts.dart';

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
    print('Porta: ${condominio.boiaStatusCisternaBomba}');
    print('Energia: ${condominio.faseStatusBomba}');
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
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            if (condominio.faseStatusBomba != null)
              InfoRow(
                label: "Energia",
                value:
                    condominio.faseStatusBomba == "true" ? "Normal" : "Normal",
                statusColor:
                    condominio.faseStatusBomba == "true"
                        ? Colors.green
                        : const Color.fromARGB(255, 54, 244, 63),
              ),

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
            if (condominio.boiaStatusCisternaBomba != null)
              InfoRow(
                label: "Porta",
                value:
                    // ignore: unrelated_type_equality_checks
                    condominio.boiaStatusCisternaBomba == "true"
                        ? "Aberta"
                        : "Fechada",
                statusColor: null,
              ),
          ],
        ),
      ),
    );
  }
}
