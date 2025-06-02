import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    Text(
                      "Configurações do Sistema",
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Divider(),

                    _buildSettingItem(
                      "Notificações",
                      "Gerenciar notificações do sistema",
                      Icons.notifications_on,
                          () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/notificacao_teste',
                              (route) => false,
                        );
                      },
                    ),

                    const Divider(),

                    _buildSettingItem(
                      "Usuarios",
                      "Gerenciar usuários do sistema",
                      Icons.person,
                          () {},
                    ),

                    const Divider(),
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
        style: GoogleFonts.quicksand(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        description,
        style: GoogleFonts.quicksand(),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}