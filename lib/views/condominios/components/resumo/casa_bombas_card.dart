import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:flutter_mks_app/views/condominios/components/resumo/info_row.dart'; // Importe o InfoRow

class CasaBombasCard extends StatelessWidget {
  final String titulo;
  final CondominioModel condominio;
  final String energia;
  final String operacao;
  final String rodizio;
  final String porta;

  const CasaBombasCard({
    super.key,
    required this.titulo,
    required this.condominio,
    required this.energia,
    required this.operacao,
    required this.rodizio,
    required this.porta,
    List<Map<String, dynamic>>? bombas,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            // Energia 220V
            InfoRow(
              label: "Energia 220V",
              value: energia == 'true' ? 'Falha' : 'Normal',
              statusColor: energia == 'true' ? Colors.red : Colors.green,
            ),

            // Operação
            InfoRow(
              label: "Operação",
              value: operacao == 'true' ? 'Remota' : 'Local',
            ),

            // Porta
            InfoRow(
              label: "Porta",
              value: porta == 'true' ? 'Aberta' : 'Fechada',
            ),

            // Rodízio
            InfoRow(
              label: "Rodízio",
              value: rodizio == 'true' ? 'Habilitado' : 'Desabilitado',
            ),
          ],
        ),
      ),
    );
  }
}
