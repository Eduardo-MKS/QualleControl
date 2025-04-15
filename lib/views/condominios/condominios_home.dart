import 'package:flutter/material.dart';

// Model para representar dados do condomínio
class CondominioModel {
  final String nome;
  final double nivelReservatorioPercentual;
  final double nivelReservatorioMetros;
  final DateTime ultimaAtualizacao;

  CondominioModel({
    required this.nome,
    required this.nivelReservatorioPercentual,
    required this.nivelReservatorioMetros,
    required this.ultimaAtualizacao,
  });
}

// Tela inicial modificada
class CondoHome extends StatelessWidget {
  CondoHome({super.key});

  // Lista de dados dos condomínios
  final List<CondominioModel> condominios = [
    CondominioModel(
      nome: "Edifício Missouri",
      nivelReservatorioPercentual: 53.95,
      nivelReservatorioMetros: 0.97,
      ultimaAtualizacao: DateTime.now(),
    ),
    CondominioModel(
      nome: "Condomínio Quinta das Palmeiras",
      nivelReservatorioPercentual: 67.30,
      nivelReservatorioMetros: 1.25,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    CondominioModel(
      nome: "Edifício Tailândia",
      nivelReservatorioPercentual: 45.20,
      nivelReservatorioMetros: 0.82,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    CondominioModel(
      nome: "Prefeitura Blumenau",
      nivelReservatorioPercentual: 78.10,
      nivelReservatorioMetros: 1.48,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    CondominioModel(
      nome: "Edifício WZ Home Park",
      nivelReservatorioPercentual: 32.75,
      nivelReservatorioMetros: 0.68,
      ultimaAtualizacao: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];

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
                          Image(
                            image: AssetImage('assets/ehoteste.png'),
                            height: 20,
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(6),
                            child: Image(
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

          // Cards centralizados na transição entre azul e branco
          Positioned(
            top: topSectionHeight - 10, // Posicionado para sobrepor a transição
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 450,
                child: PageView.builder(
                  itemCount: condominios.length,
                  controller: PageController(viewportFraction: 1.0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navegação para tela de detalhes com dados do condomínio
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CondominioDetalhesScreen(
                                    condominio: condominios[index],
                                  ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                size: 55,
                                color: const Color.fromARGB(255, 49, 145, 148),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                condominios[index].nome,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Toque para ver detalhes',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 49, 145, 148),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Filtros'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alarmes',
          ),
        ],
      ),
    );
  }
}

// Tela de detalhes do condomínio
class CondominioDetalhesScreen extends StatelessWidget {
  final CondominioModel condominio;

  const CondominioDetalhesScreen({super.key, required this.condominio});

  @override
  Widget build(BuildContext context) {
    // Formato de data e hora
    String dataFormatada = _formatarData(condominio.ultimaAtualizacao);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
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
                _buildNavButton("Resumo", true),
                _buildNavButton("Análise", false),
                _buildNavButton("Alarmes", false),
                _buildNavButton("Ações", false),
                _buildNavButton("Configurações", false),
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
                      child: Stack(
                        children: [
                          // Gráfico de barras para representar nível da água
                          _buildReservatorioChart(
                            condominio.nivelReservatorioPercentual,
                          ),

                          // Marcador de "Cota Bombeiros"
                          Positioned(
                            top: 50,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "Cota Bombeiros",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 49, 145, 148),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: '',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  // Constrói o botão de navegação
  Widget _buildNavButton(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue.shade900 : Colors.white,
          side: BorderSide(
            color: isSelected ? Colors.blue.shade900 : Colors.grey.shade400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  // Formata a data
  String _formatarData(DateTime data) {
    String dia = data.day.toString().padLeft(2, '0');
    String mes = data.month.toString().padLeft(2, '0');
    String ano = data.year.toString();
    String hora = data.hour.toString().padLeft(2, '0');
    String minuto = data.minute.toString().padLeft(2, '0');
    String segundo = data.second.toString().padLeft(2, '0');

    return "$dia/$mes/$ano $hora:$minuto:$segundo";
  }

  // Constrói o gráfico do reservatório
  Widget _buildReservatorioChart(double nivelPercentual) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          // Fundo do gráfico (representando a capacidade total)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.purple.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Preenchimento do nível atual
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 160 * (nivelPercentual / 100),
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
