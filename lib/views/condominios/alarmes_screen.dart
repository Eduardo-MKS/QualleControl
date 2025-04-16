import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/widgets/custom_bottom_nav_bar.dart';

class AlarmesScreen extends StatefulWidget {
  const AlarmesScreen({super.key});

  @override
  State<AlarmesScreen> createState() => _AlarmesScreenState();
}

class _AlarmesScreenState extends State<AlarmesScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 1;
  TextEditingController inicioController = TextEditingController(
    text: "15/04/2025 10:26",
  );
  TextEditingController finalController = TextEditingController(
    text: "16/04/2025 10:26",
  );

  void openDrawer(BuildContext context) {
    scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Histórico de Alarmes Gerais',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 196, 83, 83),
        elevation: 0,
        centerTitle: true,
      ),
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
            ListTile(
              leading: const Icon(Icons.person_2),
              title: const Text('eDecussi'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_callback),
              title: const Text('Plantão'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tabela de Alarmes
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cabeçalho da tabela
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          _buildHeaderCell('Data', width: 0.25, showSort: true),
                          _buildHeaderCell(
                            'Alarme',
                            width: 0.35,
                            showSort: true,
                          ),
                          _buildHeaderCell(
                            'Valor Atual',
                            width: 0.20,
                            showSort: true,
                          ),
                          _buildHeaderCell('Setpoint', width: 0.20),
                        ],
                      ),
                    ),
                  ),

                  // Registros da tabela
                  Column(
                    children: [
                      _buildDataRow(
                        '16/04/2025\n10:17:02',
                        'Nível Baixo',
                        '2.36',
                        '6',
                        false,
                      ),
                      _buildDataRow(
                        '16/04/2025\n10:17:02',
                        'Nível Baixo',
                        '2.36',
                        '6',
                        false,
                      ),
                      _buildDataRow(
                        '16/04/2025\n10:06:57',
                        'Nível Baixo -\nNORMALIZADO',
                        '3.22',
                        '6',
                        true,
                      ),
                      _buildDataRow(
                        '16/04/2025\n10:06:22',
                        'Nível Baixo -\nNORMALIZADO',
                        '109.05',
                        '120',
                        false,
                      ),
                      _buildDataRow(
                        '16/04/2025\n10:06:07',
                        'Corrente Baixa -\nNORMALIZADO',
                        '0.98',
                        '9',
                        true,
                      ),
                      _buildDataRow(
                        '16/04/2025\n10:05:38',
                        'Corrente Alta -\nNORMALIZADO',
                        '0',
                        '9',
                        false,
                      ),
                      _buildDataRow(
                        '16/04/2025\n10:05:38',
                        'Corrente Alta -\nNORMALIZADO',
                        '0',
                        '9',
                        false,
                      ),
                    ],
                  ),

                  // Paginação
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPaginationButton('1', isSelected: true),
                        _buildPaginationButton('2'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            // Período da Consulta
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Período da Consulta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const SizedBox(width: 8.0),
                      const Text('Início'),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextField(
                          controller: inicioController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const SizedBox(width: 8.0),
                      const Text('Final'),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextField(
                          controller: finalController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para buscar alarmes no período selecionado
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F5597),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                        ),
                        child: const Text('Buscar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        showLabels: true,
        currentIndex: 2,
        openDrawer: openDrawer,
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    required double width,
    bool showSort = false,
  }) {
    return Expanded(
      flex: (width * 100).toInt(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
            if (showSort)
              const Icon(
                Icons.arrow_drop_down,
                size: 16.0,
                color: Colors.black54,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(
    String data,
    String alarme,
    String valorAtual,
    String setpoint,
    bool isGray,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isGray ? const Color(0xFFF8F8F8) : Colors.white,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 25,
              child: Text(
                data,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.0),
              ),
            ),
            Expanded(
              flex: 35,
              child: Text(
                alarme,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.0),
              ),
            ),
            Expanded(
              flex: 20,
              child: Text(
                valorAtual,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.0),
              ),
            ),
            Expanded(
              flex: 20,
              child: Text(
                setpoint,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationButton(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2F5597) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF2F5597) : Colors.grey,
          width: 1.0,
        ),
      ),
      width: 28.0,
      height: 28.0,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
