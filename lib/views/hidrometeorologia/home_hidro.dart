import 'package:flutter/material.dart';
import 'widgets/filter_sidebar.dart';
import 'widgets/map_view.dart';
import 'widgets/cameras_view.dart';
import 'widgets/profile_view.dart';

class HomeHidro extends StatefulWidget {
  const HomeHidro({super.key});

  @override
  State<HomeHidro> createState() => _HomeHidroState();
}

class _HomeHidroState extends State<HomeHidro> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFilterSidebarOpen = false;
  late AnimationController _sidebarAnimationController;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    _sidebarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sidebarAnimation = Tween<double>(begin: -300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _sidebarAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  void _toggleFilterSidebar() {
    setState(() {
      _isFilterSidebarOpen = !_isFilterSidebarOpen;
    });

    if (_isFilterSidebarOpen) {
      _sidebarAnimationController.forward();
    } else {
      _sidebarAnimationController.reverse();
    }
  }

  void _onBottomNavTap(int index) {
    // Se não estiver no mapa e tentar acessar filtros, não faz nada
    if (index == 1 && _currentIndex != 0) {
      return;
    }

    if (index == 1) {
      // Filtros - só funciona quando está no mapa (_currentIndex == 0)
      _toggleFilterSidebar();
    } else {
      // Se o sidebar estiver aberto e navegarmos para outra aba, fechamos o sidebar
      if (_isFilterSidebarOpen) {
        _toggleFilterSidebar();
      }
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // Função para determinar se deve mostrar o botão de filtros
  bool _shouldShowFiltersButton() {
    return _currentIndex == 0; // Só mostra quando estiver no mapa
  }

  // Função para construir os itens da bottom navigation
  List<BottomNavigationBarItem> _buildBottomNavItems() {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
    ];

    // Só adiciona o botão de filtros se estiver no mapa
    if (_shouldShowFiltersButton()) {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.filter_alt,
            color: _isFilterSidebarOpen ? Colors.blue[600] : null,
          ),
          label: 'Filtros',
        ),
      );
    }

    items.addAll([
      const BottomNavigationBarItem(
        icon: Icon(Icons.videocam),
        label: 'Cameras',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Importante: extendBody permite que o sidebar fique por cima da bottom navigation
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: const [MapView(), CamerasView(), ProfileView()],
          ),

          // Overlay escuro quando sidebar está aberto
          if (_isFilterSidebarOpen)
            GestureDetector(
              onTap: _toggleFilterSidebar,
              child: Container(
                color: Colors.black26,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          // Sidebar de filtros - movido para o final para ficar por cima
          if (_currentIndex ==
              0) // Só renderiza o sidebar quando estiver no mapa
            AnimatedBuilder(
              animation: _sidebarAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_sidebarAnimation.value, 0),
                  child: FilterSidebar(onClose: _toggleFilterSidebar),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex:
            _shouldShowFiltersButton()
                ? _currentIndex
                : (_currentIndex > 0 ? _currentIndex - 1 : 0),
        onTap: (index) {
          if (_shouldShowFiltersButton()) {
            _onBottomNavTap(index);
          } else {
            // Ajustar índices quando filtros não estiver visível
            if (index >= 1) {
              _onBottomNavTap(index + 1);
            } else {
              _onBottomNavTap(index);
            }
          }
        },
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[600],
        items: _buildBottomNavItems(),
      ),
    );
  }
}
