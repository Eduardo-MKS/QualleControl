// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_mks_app/controller/condominio_controller.dart';
import 'package:flutter_mks_app/controller/plantao_controller.dart';
import 'package:flutter_mks_app/models/plantao_model.dart';
import 'package:flutter_mks_app/views/condominios/condo_detalhes_screen.dart';
import 'package:flutter_mks_app/views/widgets/custom_bottom_nav_bar.dart';
import 'components/condo_card.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CondoHome extends StatefulWidget {
  const CondoHome({super.key});

  @override
  State<CondoHome> createState() => _CondoHomeState();
}

class _CondoHomeState extends State<CondoHome> {
  final CondominioController _condominioController = CondominioController();
  final PlantaoController _plantaoController = PlantaoController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _condominioController.initialize();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _openDrawer(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
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

  Widget _buildSplashScreen() {
    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/ehoteste.png'),
                  height: 40,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  child: const Image(
                    image: AssetImage('assets/simbolo-cond.png'),
                    height: 80,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSplashScreen();
    }

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
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 350,
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
              ),
              Expanded(child: Container(color: Colors.white)),
            ],
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(9.0),
                        child: Text(
                          "Olá,\nAdmin!",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
                child:
                    _condominioController.condominios.isEmpty
                        ? const Center(
                          child: Text(
                            "Nenhum condomínio encontrado",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : PageView.builder(
                          itemCount: _condominioController.condominios.length,
                          controller: PageController(viewportFraction: 1.0),
                          itemBuilder: (context, index) {
                            final condominio =
                                _condominioController.condominios[index];
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
                              reservatorioText: 'erer',
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
