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

  void _onBottomNavTap(int navIndex) {
    int realIndex;

    if (_currentIndex == 0) {
      if (navIndex == 1) {
        _toggleFilterSidebar();
        return;
      } else if (navIndex == 2) {
        realIndex = 1;
      } else if (navIndex == 3) {
        realIndex = 2;
      } else {
        realIndex = 0;
      }
    } else {
      if (navIndex == 0) {
        realIndex = 0;
      } else if (navIndex == 1) {
        realIndex = 1;
      } else {
        realIndex = 2;
      }
    }

    if (_isFilterSidebarOpen) {
      _toggleFilterSidebar();
    }

    setState(() {
      _currentIndex = realIndex;
    });
  }

  bool _shouldShowFiltersButton() {
    return _currentIndex == 0;
  }

  // Função para construir os itens da bottom navigation
  List<BottomNavigationBarItem> _buildBottomNavItems() {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
    ];

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

  int _getBottomNavIndex() {
    if (_currentIndex == 0) {
      return 0;
    } else if (_currentIndex == 1) {
      return _shouldShowFiltersButton() ? 2 : 1;
    } else if (_currentIndex == 2) {
      return _shouldShowFiltersButton() ? 3 : 2;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: const [MapView(), CamerasView(), ProfileView()],
          ),

          if (_isFilterSidebarOpen)
            GestureDetector(
              onTap: _toggleFilterSidebar,
              child: Container(
                color: Colors.black26,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (_currentIndex == 0)
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
        currentIndex: _getBottomNavIndex(),
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[600],
        items: _buildBottomNavItems(),
      ),
    );
  }
}
