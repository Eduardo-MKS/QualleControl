import 'package:flutter/material.dart';

// Model class for client data
class Client {
  final String id;
  final String name;

  final List<SubClient> subClients;

  Client({required this.id, required this.name, this.subClients = const []});
}

// Model class for sub-client data
class SubClient {
  final String id;
  final String name;
  final String clientId;

  SubClient({required this.id, required this.name, required this.clientId});
}

// ignore: camel_case_types
class azazHome extends StatefulWidget {
  const azazHome({super.key});

  @override
  State<azazHome> createState() => _azazHomeState();
}

// ignore: camel_case_types
class _azazHomeState extends State<azazHome> {
  final List<Client> allClients = [
    Client(
      id: '1',
      name: 'TITO',

      subClients: [SubClient(id: '1-1', name: 'PCH São Luís', clientId: '1')],
    ),
    Client(
      id: '2',
      name: 'CERAN',

      subClients: [
        SubClient(id: '2-1', name: 'CERAN - UHE 14 de Julho', clientId: '2'),
        SubClient(id: '2-2', name: 'CERAN - UHE Castro Alves', clientId: '2'),
        SubClient(id: '2-3', name: 'CERAN - UHE Monte Claro', clientId: '2'),
      ],
    ),
    Client(
      id: '3',
      name: 'CPFL',

      subClients: [
        SubClient(id: '3-1', name: 'CPFL - PCH Lucia Cherobim', clientId: '3'),
      ],
    ),
    Client(
      id: '4',
      name: 'DCSP',
      subClients: [
        SubClient(id: '4-1', name: 'DC SP - Capivari', clientId: '4'),
        SubClient(
          id: '4-2',
          name: 'DC SP - Ferraz de Vasconcelos',
          clientId: '4',
        ),
        SubClient(id: '4-3', name: 'DC SP - Francisco Morato', clientId: '4'),
        SubClient(
          id: '4-4',
          name: 'DC SP - São Luiz do Paraitinga',
          clientId: '4',
        ),
      ],
    ),
  ];

  List<Client> filteredClients = [];
  final TextEditingController searchController = TextEditingController();

  // Para controlar se estamos mostrando clientes ou sub-clientes
  bool showingSubClients = false;
  Client? selectedClient;
  List<SubClient> currentSubClients = [];

  // Para controlar o estado do dropdown
  bool isDropdownOpen = false;
  String filterOption = "Todos";

  // Controller and layerLink for dropdown overlay
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    filteredClients = List.from(allClients);

    // Adicionar listener para atualizar a lista filtrada quando o texto mudar
    searchController.addListener(() {
      filterClients();
    });
  }

  void filterClients() {
    if (searchController.text.isEmpty) {
      setState(() {
        filteredClients = List.from(allClients);
      });
    } else {
      setState(() {
        filteredClients =
            allClients
                .where(
                  (client) => client.name.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
                )
                .toList();
      });
    }
  }

  // Função para mostrar sub-clientes de um cliente específico
  void showSubClients(Client client) {
    setState(() {
      showingSubClients = true;
      selectedClient = client;
      currentSubClients = client.subClients;
    });
  }

  // Função para voltar à lista de clientes
  void showAllClients() {
    setState(() {
      showingSubClients = false;
      selectedClient = null;
    });
  }

  // Show the dropdown overlay
  void _showDropdownOverlay() {
    // Remove any existing overlay first
    _removeDropdownOverlay();

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      isDropdownOpen = true;
    });
  }

  // Remove the dropdown overlay
  void _removeDropdownOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  // Create the dropdown overlay entry
  OverlayEntry _createOverlayEntry() {
    // Find the render box
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width - 40, // Match parent width minus padding
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0.0, 50.0), // Adjust this value as needed
              child: Material(
                elevation: 8.0,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      if (!showingSubClients) ...[
                        // Opção "Todos"
                        ListTile(
                          title: const Text(
                            "Todos",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              filterOption = "Todos";
                              filteredClients = List.from(allClients);
                            });
                            _removeDropdownOverlay();
                          },
                        ),
                        // Opções para cada cliente disponível
                        ...allClients.map(
                          (client) => ListTile(
                            title: Text(
                              client.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                filterOption = client.name;
                                filteredClients = [client];
                              });
                              _removeDropdownOverlay();
                            },
                          ),
                        ),
                      ] else ...[
                        // Opção para voltar para todos os clientes
                        ListTile(
                          title: const Text(
                            "Voltar para todos",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              showAllClients();
                              filterOption = "Todos";
                            });
                            _removeDropdownOverlay();
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    // Make sure to remove any overlay when disposing
    _removeDropdownOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fundo com gradiente e borda arredondada
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF5EBAA0), // Verde azulado
                        Color(0xFF9EDB49), // Verde claro
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(flex: 6, child: Container()),
            ],
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Olá,\nEduardo!",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Logo no canto superior direito
                      Row(
                        children: [
                          Image(
                            image: const AssetImage('assets/ehoteste.png'),
                            height: 15,
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Image(
                              image: AssetImage('assets/simbolo-azas.png'),
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Campo de busca e dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showingSubClients
                            ? "Sub-clientes de ${selectedClient?.name}"
                            : "Busque o cliente desejado",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Dropdown de seleção com funcionalidade
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: GestureDetector(
                          onTap: () {
                            if (isDropdownOpen) {
                              _removeDropdownOverlay();
                            } else {
                              _showDropdownOverlay();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  showingSubClients
                                      ? selectedClient!.name
                                      : filterOption,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  isDropdownOpen
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Lista de clientes ou sub-clientes
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child:
                        showingSubClients
                            ? _buildSubClientsList()
                            : _buildClientsList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para lista de clientes
  Widget _buildClientsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredClients.length,
      separatorBuilder:
          (context, index) => const Divider(color: Colors.grey, height: 1),
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        return ListTile(
          title: Text(
            client.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          onTap: () {
            // Mostrar sub-clientes ao clicar no cliente
            showSubClients(client);
          },
        );
      },
    );
  }

  // Widget para lista de sub-clientes
  Widget _buildSubClientsList() {
    return Column(
      children: [
        // Botão para voltar para a lista de clientes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: showAllClients,
            child: Row(
              children: const [
                Icon(Icons.arrow_back, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Voltar para clientes",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Lista de sub-clientes
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: currentSubClients.length,
            separatorBuilder:
                (context, index) =>
                    const Divider(color: Colors.grey, height: 1),
            itemBuilder: (context, index) {
              final subClient = currentSubClients[index];
              return ListTile(
                title: Text(
                  "${selectedClient!.name} - ${subClient.name}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Ação ao clicar no sub-cliente
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Sub-cliente selecionado: ${subClient.name}",
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
