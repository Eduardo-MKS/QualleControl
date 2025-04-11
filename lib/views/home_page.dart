// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Função para lidar com o logout
  void _handleLogout(BuildContext context) {
    // Exibe um diálogo de confirmação
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Deseja realmente sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // Fechar o diálogo
                  Navigator.pop(context);

                  // Implementação do logout
                  // Aqui você pode adicionar a lógica de limpar sessão, tokens, etc.

                  // Navegar para a tela de login
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Sair'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'qualle control',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text(
                  'Sistemas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3A3A),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSystemCard(
                          context: context,
                          title: 'qualle control',
                          subtitle: 'A-ZAS',
                          color: Colors.green,
                          route: '/azas',
                        ),
                        const SizedBox(height: 16),
                        _buildSystemCard(
                          context: context,
                          title: 'qualle control',
                          subtitle: 'Condomínios',
                          color: Colors.red,
                          route: '/condominios',
                        ),
                        const SizedBox(height: 16),
                        _buildSystemCard(
                          context: context,
                          title: 'qualle control',
                          subtitle: 'Hidrometeorologia',
                          color: Colors.amber,
                          route: '/hidrometeorologia',
                        ),
                        const SizedBox(height: 16),
                        _buildSystemCard(
                          context: context,
                          title: 'qualle control',
                          subtitle: 'Saneamento',
                          color: Colors.lightBlue,
                          route: '/saneamento',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Desenvolvido por ',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'MKS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Ícone de usuário com ação de logout
                    InkWell(
                      onTap: () => _handleLogout(context),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[800],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Aqui você pode adicionar uma imagem futuramente
                  // Image.asset('assets/images/icon_$subtitle.png', width: 40, height: 40),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
