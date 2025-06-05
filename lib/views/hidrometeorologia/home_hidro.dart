import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  final LatLng _scCenter = LatLng(-27.5954, -48.5480);

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
        icon: Icon(Icons.video_camera_front),
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
            children: [
              _buildMapView(),
              _buildReportsView(),
              _buildProfileView(),
            ],
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
                  child: _buildFilterSidebar(),
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

  Widget _buildFilterSidebar() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Material(
        elevation: 1, // Adiciona sombra para ficar claramente por cima
        child: Container(
          width: 300,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do sidebar
                Container(
                  padding: const EdgeInsets.all(16),

                  child: Row(
                    children: [
                      const SizedBox(width: 12),

                      const Spacer(),
                      IconButton(
                        onPressed: _toggleFilterSidebar,
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Conteúdo dos filtros
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        const Spacer(),

                        // Botões de ação
                        SizedBox(child: Text('Desenvolvido por')),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _scCenter,
        initialZoom: 7.0,
        minZoom: 5.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.hidrometeorologia',
          maxZoom: 18,
        ),

        Positioned(
          top: 20,
          right: 20,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: "zoom_in",
                onPressed: () {},
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: "zoom_out",
                onPressed: () {},
                backgroundColor: Colors.white,
                child: const Icon(Icons.remove, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportsView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Cameras',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'EmMMM...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_camera_front, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Cameras',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Em desenvolvimento...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
