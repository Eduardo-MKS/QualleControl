import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/condominios/detalhes/acoes_component.dart';
import 'package:flutter_mks_app/views/condominios/detalhes/alarmes_component.dart';
import 'package:flutter_mks_app/views/condominios/detalhes/analise_component.dart';
import 'package:flutter_mks_app/views/condominios/detalhes/configuracoes_component.dart';
import 'package:flutter_mks_app/views/condominios/detalhes/resumo_component.dart';
import '../../models/condominio_model.dart';
import '../../utils/formatters.dart';
import 'components/nav_button.dart';

// Define the enum at the top level instead of inside the class
enum NavTab { resumo, analise, acoes, alarmes, configuracoes }

class CondominioDetalhesScreen extends StatefulWidget {
  final CondominioModel condominio;

  const CondominioDetalhesScreen({super.key, required this.condominio});

  @override
  State<CondominioDetalhesScreen> createState() =>
      _CondominioDetalhesScreenState();
}

class _CondominioDetalhesScreenState extends State<CondominioDetalhesScreen> {
  // Default selected tab
  NavTab _selectedTab = NavTab.resumo;

  @override
  Widget build(BuildContext context) {
    // Formato de data e hora
    String dataFormatada =
        widget.condominio.ultimaAtualizacao != null
            ? DateFormatter.formatarData(widget.condominio.ultimaAtualizacao!)
            : 'Não atualizado';

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
          // Header section with condominium name and update time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.condominio.nome,
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

          // Navigation menu
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
                  onTap: () {
                    setState(() {
                      _selectedTab = NavTab.resumo;
                    });
                  },
                ),
                NavButton(
                  icon: Icons.analytics,
                  label: "Analise",
                  isSelected: _selectedTab == NavTab.analise,
                  onTap: () {
                    setState(() {
                      _selectedTab = NavTab.analise;
                    });
                  },
                ),
                NavButton(
                  icon: Icons.man_sharp,
                  label: "Ações",
                  isSelected: _selectedTab == NavTab.acoes,
                  onTap: () {
                    setState(() {
                      _selectedTab = NavTab.acoes;
                    });
                  },
                ),
                NavButton(
                  icon: Icons.notifications,
                  label: "Alarmes",
                  isSelected: _selectedTab == NavTab.alarmes,
                  onTap: () {
                    setState(() {
                      _selectedTab = NavTab.alarmes;
                    });
                  },
                ),
                NavButton(
                  icon: Icons.settings,
                  label: "Configurações",
                  isSelected: _selectedTab == NavTab.configuracoes,
                  onTap: () {
                    setState(() {
                      _selectedTab = NavTab.configuracoes;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Dynamic content area that changes based on selected tab
          Expanded(child: _buildSelectedContent()),
        ],
      ),
    );
  }

  // Method to build the content based on selected tab
  Widget _buildSelectedContent() {
    switch (_selectedTab) {
      case NavTab.resumo:
        return ResumoScreen(condominio: widget.condominio);
      case NavTab.analise:
        return AnaliseComponent(condominio: widget.condominio);
      case NavTab.acoes:
        return AcoesComponent(condominio: widget.condominio);
      case NavTab.alarmes:
        return AlarmesComponent(condominio: widget.condominio);
      case NavTab.configuracoes:
        return ConfiguracoesComponent(condominio: widget.condominio);
    }
  }
}
