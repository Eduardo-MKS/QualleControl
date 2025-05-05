import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';

class CasaBombasCard extends StatelessWidget {
  final String titulo;
  final CondominioModel condominio;
  final String energia;
  final String operacao;
  final String rodizio;
  final String porta;

  const CasaBombasCard({
    Key? key,
    required this.titulo,
    required this.condominio,
    required this.energia,
    required this.operacao,
    required this.rodizio,
    required this.porta,
    List<Map<String, dynamic>>? bombas,
  }) : super(key: key);

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
            // Primeira linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Energia 220V
                Row(
                  children: [
                    const Text(
                      'Energia 220V',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Status da Energia
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        energia == 'true'
                            ? const Color.fromARGB(255, 195, 74, 74)
                            : const Color(0xFF8BC34A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    energia == 'true' ? 'Falha' : 'Normal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Operação
                const Text(
                  'Operação',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Status da Operação
                Text(
                  operacao == 'true' ? 'Remota' : 'Local',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Segunda linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Porta
                const Text(
                  'Porta',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Status da Porta
                Text(
                  porta == 'true' ? 'Aberta' : 'Fechada',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                // Rodízio
                const Text(
                  'Rodízio',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Status do Rodízio
                Text(
                  rodizio == 'true' ? 'Habilitado' : 'Desabilitado',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
