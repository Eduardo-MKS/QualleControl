import 'package:flutter/material.dart';
import 'package:flutter_mks_app/controller/condominio_controller.dart';
import 'package:flutter_mks_app/views/condominios/condo_detalhes_screen.dart';

import '../widgets/custom_bottom_nav_bar.dart';
import 'components/condo_card.dart';

class CondoHome extends StatelessWidget {
  CondoHome({super.key});

  final CondominioController _controller = CondominioController();

  @override
  Widget build(BuildContext context) {
    // Altura da seção superior com gradiente
    final double topSectionHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fundo com gradiente na parte superior
          Column(
            children: [
              Container(
                height: topSectionHeight,
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
      bottomNavigationBar: const CustomBottomNavBar(showLabels: true),
    );
  }
}
