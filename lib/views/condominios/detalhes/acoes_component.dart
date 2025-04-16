import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';

class AcoesComponent extends StatelessWidget {
  final CondominioModel condominio;

  const AcoesComponent({super.key, required this.condominio});

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
                      "Ações Disponíveis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lista de ações
                    _buildActionItem(
                      "Ativar Bomba",
                      "Iniciar bombeamento manual",
                      Icons.play_circle_filled,
                      Colors.green,
                      () {
                        // Ação para ativar bomba
                      },
                    ),

                    const Divider(),

                    _buildActionItem(
                      "Parar Bomba",
                      "Interromper bombeamento",
                      Icons.stop_circle,
                      Colors.red,
                      () {
                        // Ação para parar bomba
                      },
                    ),

                    const Divider(),

                    _buildActionItem(
                      "Teste de Bombas",
                      "Realizar teste de funcionamento",
                      Icons.build,
                      Colors.blue,
                      () {
                        // Ação para testar bomba
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(description),
      trailing: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        child: const Text("Executar"),
      ),
    );
  }
}
