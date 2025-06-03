import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_row.dart';
import 'package:google_fonts/google_fonts.dart';

class PainelReservatorioCard extends StatelessWidget {
  final String titulo;
  final String bateria;
  final String painelBateria;
  final CondominioModel condominio;

  const PainelReservatorioCard({
    super.key,
    required this.titulo,
    required this.bateria,
    required this.condominio,
    required this.painelBateria,
  });

  @override
  Widget build(BuildContext context) {
    print('Boia: ${condominio.boiaStatusReservatorio}');
    print('Porta: ${condominio.portaReservatorioteste}');
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
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: Colors.black),
            const SizedBox(height: 8),

            if (condominio.painelEnergia != null)
              InfoRow(
                label: "Energia 220V",
                value: condominio.painelEnergia == true ? "Normal" : "Falta",
                statusColor:
                    condominio.painelEnergia == true
                        ? Colors.green
                        : Colors.red,
              ),

            if (condominio.faseEnergia != null)
              InfoRow(
                value: condominio.faseEnergia == true ? "Normal" : "Falta",
                statusColor:
                    condominio.faseEnergia == true ? Colors.green : Colors.red,
                label: 'Energia 220V',
              ),

            if (condominio.painelLed != null)
              InfoRow(
                label: "LED",
                value: condominio.painelLed == true ? "Desligado" : "Normal",
                statusColor:
                    condominio.painelLed == true
                        ? const Color.fromARGB(255, 233, 33, 33)
                        : const Color.fromARGB(255, 60, 185, 35),
              ),

            if (condominio.painelSirene != null)
              InfoRow(
                label: "Sirene",
                value: condominio.painelSirene == true ? "Desligada" : "Normal",
                statusColor:
                    condominio.painelSirene == true
                        ? Colors.red
                        : const Color.fromARGB(255, 53, 215, 21),
              ),

            InfoRow(label: "Bateria", value: "${painelBateria}V"),

            if (condominio.portaReservatorioteste != null)
              InfoRow(
                label: "Porta",
                value:
                    condominio.portaReservatorioteste == true
                        ? "Fechada"
                        : "Aberta",
              ),

            if (condominio.boiaStatusReservatorio != null)
              InfoRow(
                label: "Boia",
                value:
                    condominio.boiaStatusReservatorio == true
                        ? "Normal"
                        : "Vazia",
                statusColor:
                    condominio.painelSirene == true
                        ? const Color.fromARGB(255, 76, 244, 54)
                        : const Color.fromARGB(255, 215, 21, 21),
              ),
          ],
        ),
      ),
    );
  }
}
