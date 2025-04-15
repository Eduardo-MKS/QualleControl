import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final bool showLabels;
  final int currentIndex;
  final Function(BuildContext) openDrawer;

  const CustomBottomNavBar({
    super.key,
    this.showLabels = false,
    this.currentIndex = 1, // Definindo "Home" (índice 1) como o padrão
    required this.openDrawer,
  });

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
        // Abrir o drawer em vez de navegar quando clicar em Filtros
        if (index == 0) {
          openDrawer(context);
          return;
        }

        // Evitar recarregar a mesma tela
        if (index == currentIndex) return;

        switch (index) {
          case 1:
            // Navegar para a tela Home
            Navigator.pushReplacementNamed(context, '/condominios');
            break;
          case 2:
            // Navegar para a tela de Alarmes
            Navigator.pushReplacementNamed(context, '/alarmescreen');
            break;
        }
      },
    );
  }
}
