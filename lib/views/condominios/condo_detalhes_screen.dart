import 'package:flutter/material.dart';
import '../../models/condominio_model.dart';
import '../../utils/formatters.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../condominios/components/nav_button.dart';
import 'components/reservatorio_chart.dart';

class CondominioDetalhesScreen extends StatelessWidget {
  final CondominioModel condominio;

  const CondominioDetalhesScreen({super.key, required this.condominio});

  @override
  Widget build(BuildContext context) {
    // Formato de data e hora
    String dataFormatada = DateFormatter.formatarData(
      condominio.ultimaAtualizacao,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Text(
              "quelle control",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  condominio.nome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Última Atualização ",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      dataFormatada,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Menu de navegação
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                NavButton(
                  icon: Icons.home,
                  label: "Resumo",
                  isSelected: true,
                  onTap: () {
                    // Navegar para a tela de resumo
                    Navigator.pushNamed(context, '/condominios');
                  },
                ),
                NavButton(
                  icon: Icons.settings,
                  label: "Configurações",
                  isSelected: false,
                  onTap: () {},
                ),
                NavButton(
                  icon: Icons.notifications,
                  label: "Alarmes",
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Card do reservatório
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
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
                      "Reservatório",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),

                    // Gráfico do reservatório
                    SizedBox(
                      height: 180,
                      child: ReservatorioChart(
                        nivelPercentual: condominio.nivelReservatorioPercentual,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Informações de nível
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nível (%)",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${condominio.nivelReservatorioPercentual}%",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(height: 50, width: 1, color: Colors.grey),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nível (m)",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${condominio.nivelReservatorioMetros}m",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
