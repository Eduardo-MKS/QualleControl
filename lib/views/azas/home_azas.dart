import 'package:flutter/material.dart';
import 'package:flutter_mks_app/controller/client_controller.dart';
import 'package:flutter_mks_app/views/azas/components/header_widget.dart';
import 'package:flutter_mks_app/views/azas/components/client_filter_dropdown.dart';
import 'package:flutter_mks_app/views/azas/components/client_list_view.dart';
import 'package:flutter_mks_app/views/azas/components/sub_client_list_view.dart';

class AzasHome extends StatefulWidget {
  const AzasHome({Key? key}) : super(key: key);

  @override
  State<AzasHome> createState() => _AzasHomeState();
}

class _AzasHomeState extends State<AzasHome> {
  final ClientController controller = ClientController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fundo com gradiente e borda arredondada
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF5EBAA0), // Verde azulado
                        Color(0xFF9EDB49), // Verde claro
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(flex: 6, child: Container()),
            ],
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com saudação e logos
                const HeaderWidget(),

                // Campo de busca e dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.showingSubClients
                            ? "Sub-clientes de ${controller.selectedClient?.name}"
                            : "Busque o cliente desejado",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Dropdown de seleção
                      ClientFilterDropdown(controller: controller),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Lista de clientes ou sub-clientes
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        return controller.showingSubClients
                            ? SubClientListView(controller: controller)
                            : ClientListView(controller: controller);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
