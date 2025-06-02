import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_mks_app/views/condominios/detalhes/analise_component.dart';
import 'package:flutter_mks_app/views/condominios/detalhes/configuracoes_component.dart';
import 'package:flutter_mks_app/views/condominios/detalhes/resumo_component.dart';
import '../../models/condominio_model.dart';
import 'components/nav_button.dart';
import 'package:google_fonts/google_fonts.dart';

enum NavTab { resumo, analise, acoes, alarmes, configuracoes }

class CondominioDetalhesScreen extends StatefulWidget {
  final CondominioModel condominio;

  const CondominioDetalhesScreen({super.key, required this.condominio});

  @override
  State<CondominioDetalhesScreen> createState() =>
      _CondominioDetalhesScreenState();
}

class _CondominioDetalhesScreenState extends State<CondominioDetalhesScreen> {
  NavTab _selectedTab = NavTab.resumo;

  @override
  Widget build(BuildContext context) {
    try {
      tz_data.initializeTimeZones();
    } catch (e) {
      print('Erro ao inicializar timezone: $e');
    }

    final brasilTimeZone = tz.getLocation('America/Sao_Paulo');
    final brasilTime = tz.TZDateTime.now(brasilTimeZone);

    final dateFormat = DateFormat('dd/MM/yy HH:mm:ss');
    final formattedDate = dateFormat.format(brasilTime);

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
            Image(image: AssetImage('assets/ehoteste.png'), height: 20),
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
                  widget.condominio.nome,
                  style: GoogleFonts.quicksand(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Última Atualização: ",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                NavButton(
                  icon: Icons.home,
                  label: "Resumo",
                  isSelected: _selectedTab == NavTab.resumo,
                  onTap: () => setState(() => _selectedTab = NavTab.resumo),
                ),
                NavButton(
                  icon: Icons.analytics,
                  label: "Analise",
                  isSelected: _selectedTab == NavTab.analise,
                  onTap: () => setState(() => _selectedTab = NavTab.analise),
                ),

                NavButton(
                  icon: Icons.settings,
                  label: "Configurações",
                  isSelected: _selectedTab == NavTab.configuracoes,
                  onTap:
                      () => setState(() => _selectedTab = NavTab.configuracoes),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildSelectedContent()),
        ],
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedTab) {
      case NavTab.resumo:
        return ResumoScreen(condominio: widget.condominio);
      case NavTab.analise:
        return AnaliseComponent(condominio: widget.condominio);

      case NavTab.configuracoes:
        return ConfiguracoesComponent(condominio: widget.condominio);
      case NavTab.alarmes:
        // TODO: Handle this case.
        throw UnimplementedError();
      case NavTab.acoes:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
