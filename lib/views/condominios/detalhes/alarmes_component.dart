import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';

class AlarmesComponent extends StatelessWidget {
  final CondominioModel condominio;

  const AlarmesComponent({super.key, required this.condominio});

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
                      "Alarmes Ativos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lista de alarmes
                    _buildAlarmItem(
                      "Nível Crítico",
                      "O reservatório está abaixo de 20%",
                      Colors.red,
                      DateTime.now().subtract(const Duration(hours: 2)),
                    ),

                    const Divider(),

                    _buildAlarmItem(
                      "Falha na Bomba",
                      "Bomba 2 com problemas técnicos",
                      Colors.orange,
                      DateTime.now().subtract(const Duration(days: 1)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

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
                      "Configurar Alarmes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Conteúdo para configuração de alarmes
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmItem(
    String title,
    String description,
    Color color,
    DateTime time,
  ) {
    return ListTile(
      leading: Icon(Icons.warning_amber_rounded, color: color, size: 30),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: color,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          const SizedBox(height: 5),
          Text(
            "Ativo desde: ${_formatDate(time)}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.notifications_off),
        onPressed: () {
          // Silenciar alarme
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
