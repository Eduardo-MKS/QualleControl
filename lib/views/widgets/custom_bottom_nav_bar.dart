import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final bool showLabels;
  final int currentIndex;

  // ignore: use_super_parameters
  const CustomBottomNavBar({
    Key? key,
    this.showLabels = false,
    this.currentIndex = 1, // Definindo "Home" (índice 1) como o padrão
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color.fromARGB(255, 49, 145, 148),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_outlined),
          activeIcon: Icon(Icons.menu),
          label: 'Filtros',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Alarmes',
        ),
      ],
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      onTap: (index) {
        // Evitar recarregar a mesma tela
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            // Navegar para a tela de Filtros
            Navigator.pushReplacementNamed(context, '/filtros');
            break;
          case 1:
            // Navegar para a tela Home
            Navigator.pushReplacementNamed(context, '/condominios');
            break;
          case 2:
            // Navegar para a tela de Alarmes
            Navigator.pushReplacementNamed(context, '/alarmes');
            break;
        }
      },
    );
  }
}
