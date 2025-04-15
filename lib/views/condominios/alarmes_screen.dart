import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/widgets/custom_bottom_nav_bar.dart';

class AlarmesScreen extends StatelessWidget {
  const AlarmesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    void openDrawer(BuildContext context) {
      scaffoldKey.currentState?.openDrawer();
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 49, 145, 148), // Verde azulado
                    Color.fromARGB(255, 86, 188, 190), // Verde claro
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo no cabeçalho do drawer
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage('assets/ehoteste.png'),
                          height: 20,
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(6),
                          child: const Image(
                            image: AssetImage('assets/simbolo-cond.png'),
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Adicione aqui as opções de filtro que você deseja
            ListTile(
              leading: const Icon(Icons.person_2),
              title: const Text('eDecussi'),
              onTap: () {
                // Lógica de filtro por condomínio
                Navigator.pop(context); // Fecha o drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_callback),
              title: const Text('Plantão'),
              onTap: () {
                // Lógica de filtro por consumo
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                // Lógica de sair
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Alarmes', style: TextStyle(fontSize: 24)),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        showLabels: true,
        currentIndex: 2,
        openDrawer: openDrawer,
      ),
    );
  }
}
