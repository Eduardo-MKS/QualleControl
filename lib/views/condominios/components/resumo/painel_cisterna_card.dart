import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_row.dart';

class PainelCisternaCard extends StatelessWidget {
  final String titulo;
  final CondominioModel condominio;
  final String bateria;

  // ignore: use_super_parameters
  const PainelCisternaCard({
    Key? key,
    required this.titulo,
    required this.condominio,
    required this.bateria,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            InfoRow(label: 'Energia 220V', value: 'Normal'),

            InfoRow(
              label: 'Sirene',
              value: 'Normal',
              //valueColor: Colors.black,
              valueBackground: const Color.fromARGB(255, 20, 223, 47),
            ),
            InfoRow(
              label: 'Bateria',
              value: bateria,
              // valueColor: Colors.brown,
              valueBackground: Colors.white,
            ),
            InfoRow(
              label: 'Led',
              value: 'Normal',
              //valueColor: Colors.black,
              valueBackground: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
