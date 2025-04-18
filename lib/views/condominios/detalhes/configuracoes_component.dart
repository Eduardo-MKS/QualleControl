import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';

class ConfiguracoesComponent extends StatelessWidget {
  final CondominioModel condominio;

  const ConfiguracoesComponent({super.key, required this.condominio});

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
                      "Configurações do Sistema",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lista de configurações
                    _buildSettingItem(
                      "Intervalo de Leitura",
                      "Definir tempo entre leituras de nível",
                      Icons.timer,
                      () {
                        // Abrir configuração
                      },
                    ),

                    const Divider(),

                    _buildSettingItem(
                      "Notificações",
                      "Configurar alertas e notificações",
                      Icons.notifications_active,
                      () {
                        // Abrir configuração
                      },
                    ),

                    const Divider(),

                    _buildSettingItem(
                      "Configurações de Bomba",
                      "Definir parâmetros de acionamento",
                      Icons.settings_applications,
                      () {
                        // Abrir configuração
                      },
                    ),

                    const Divider(),

                    _buildSettingItem(
                      "Usuários",
                      "Gerenciar permissões de acesso",
                      Icons.people,
                      () {
                        // Abrir configuração
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

  Widget _buildSettingItem(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(description),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
