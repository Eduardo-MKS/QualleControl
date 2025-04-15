import 'package:flutter/material.dart';
import 'package:flutter_mks_app/controller/condominio_controller.dart';
import 'package:flutter_mks_app/views/condominios/condo_detalhes_screen.dart';
import 'package:flutter_mks_app/views/widgets/custom_bottom_nav_bar.dart';

import 'components/condo_card.dart';

class CondoHome extends StatelessWidget {
  CondoHome({super.key});

  final CondominioController _controller = CondominioController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Função para abrir o drawer
  void _openDrawer(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    // Altura da seção superior com gradiente
    final double topSectionHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      key: _scaffoldKey,
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
              title: const Text('Admin'),
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
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Fundo com gradiente na parte superior
          Column(
            children: [
              Container(
                height: 350,
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
              ),
              Expanded(child: Container(color: Colors.white)),
            ],
          ),

          // Conteúdo
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(9.0),
                        child: Text(
                          "Olá,\nEduardo!",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Logo no canto superior direito
                      Row(
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: topSectionHeight - 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 450,
                child: PageView.builder(
                  itemCount: _controller.condominios.length,
                  controller: PageController(viewportFraction: 1.0),
                  itemBuilder: (context, index) {
                    final condominio = _controller.condominios[index];
                    return CondoCard(
                      condominio: condominio,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CondominioDetalhesScreen(
                                  condominio: condominio,
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        showLabels: true,
        openDrawer: _openDrawer,
      ),
    );
  }
}
