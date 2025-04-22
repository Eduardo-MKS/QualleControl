import 'package:flutter/material.dart';
import 'package:flutter_mks_app/controller/client_controller.dart';

class SubClientListView extends StatelessWidget {
  final ClientController controller;

  const SubClientListView({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botão para voltar para a lista de clientes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: controller.showAllClients,
            child: Row(
              children: const [
                Icon(Icons.arrow_back, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Voltar para clientes",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Lista de sub-clientes
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.currentSubClients.length,
            separatorBuilder:
                (context, index) =>
                    const Divider(color: Colors.grey, height: 1),
            itemBuilder: (context, index) {
              final subClient = controller.currentSubClients[index];
              return ListTile(
                title: Text(
                  "${controller.selectedClient!.name} - ${subClient.name}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Ação ao clicar no sub-cliente
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Sub-cliente selecionado: ${subClient.name}",
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
