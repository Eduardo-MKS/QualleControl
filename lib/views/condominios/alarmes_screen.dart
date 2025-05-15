import 'package:flutter/material.dart';
import 'package:flutter_mks_app/controller/plantao_controller.dart';
import 'package:flutter_mks_app/models/plantao_model.dart';
import 'package:flutter_mks_app/views/widgets/custom_bottom_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final PlantaoController _plantaoController = PlantaoController();

  void openDrawer(BuildContext context) {
    scaffoldKey.currentState?.openDrawer();
  }

  void _showPlantaoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (_plantaoController.isLoading) {
              return const AlertDialog(
                content: Row(
                  children: [CircularProgressIndicator(), SizedBox(width: 16)],
                ),
              );
            } else if (_plantaoController.errorMessage != null) {
              return AlertDialog(
                title: const Text('Erro'),
                content: Text(_plantaoController.errorMessage!),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            } else if (_plantaoController.plantaoAtual != null) {
              final PlantaoAtual plantao = _plantaoController.plantaoAtual!;
              final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
              final String dataInicioFormatada = formatter.format(
                plantao.dataInicio!,
              );
              final String dataFinalFormatada = formatter.format(
                plantao.dataFinal!,
              );

              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Técnicos de Plantão',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      Text(
                        '$dataInicioFormatada - $dataFinalFormatada',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      if (plantao.contatoSuporte != null &&
                          plantao.contatoSuporte!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contatos - Suporte TI',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...plantao.contatoSuporte!.map(
                              (contato) => _buildContactRow(contato),
                            ),
                          ],
                        ),
                      if (plantao.contatoSuporte != null &&
                          plantao.contatoSuporte!.isNotEmpty &&
                          plantao.contatoCampo != null &&
                          plantao.contatoCampo!.isNotEmpty)
                        const Divider(),
                      if (plantao.contatoCampo != null &&
                          plantao.contatoCampo!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Contatos - Campo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...plantao.contatoCampo!.map(
                              (contato) => _buildContactRow(contato),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            } else {
              return AlertDialog(
                content: const Text('Nenhum dado de plantão disponível.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildContactRow(Contato contato) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(contato.nome ?? '', style: const TextStyle(fontSize: 14)),
          Row(
            children: [
              Text(
                contato.telefone ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              InkWell(
                child: const Icon(Icons.phone, color: Colors.green, size: 20),
                onTap: () async {
                  // Remove all non-digit characters from the phone number
                  final cleanPhone =
                      contato.telefone?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
                  print('Clean phone: $cleanPhone');

                  final Uri url = Uri.parse('https://wa.me/55$cleanPhone');
                  print('URL: $url');

                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
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
                    Color.fromARGB(255, 49, 145, 148),
                    Color.fromARGB(255, 86, 188, 190),
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
              title: const Text('Admin'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_callback),
              title: const Text('Plantão'),
              onTap: () {
                Navigator.pop(context);
                _showPlantaoDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Data',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Alarme',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Valor Atual',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Setpoint',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Registros da tabela
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
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
                      ],
                    ),
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
                          backgroundColor: const Color.fromARGB(
                            255,
                            34,
                            25,
                            112,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                        ),
                        child: const Text(
                          'Buscar',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
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
      bottomNavigationBar: CustomBottomNavBar(
        showLabels: true,
        currentIndex: 2,
        openDrawer: openDrawer,
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
}
