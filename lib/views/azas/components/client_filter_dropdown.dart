import 'package:flutter/material.dart';
import 'package:flutter_mks_app/controller/client_controller.dart';
import 'package:flutter_mks_app/models/clients_data.dart';

class ClientFilterDropdown extends StatefulWidget {
  final ClientController controller;

  const ClientFilterDropdown({super.key, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _ClientFilterDropdownState createState() => _ClientFilterDropdownState();
}

class _ClientFilterDropdownState extends State<ClientFilterDropdown> {
  bool isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDisposed = false; // Flag para verificar se o widget foi descartado

  void _showDropdownOverlay() {
    if (_isDisposed) return;

    _removeDropdownOverlay();
    _overlayEntry = _createOverlayEntry();

    // Verificação adicional antes de inserir o overlay
    if (!_isDisposed && context.mounted) {
      Overlay.of(context).insert(_overlayEntry!);
      if (mounted) {
        // Verificação adicional
        setState(() {
          isDropdownOpen = true;
        });
      }
    }
  }

  void _removeDropdownOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // Verifica se o widget ainda está montado antes de chamar setState
    if (mounted && !_isDisposed) {
      setState(() {
        isDropdownOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    // Verifica se o contexto ainda é válido
    if (!mounted || _isDisposed) {
      // Retorna um overlay vazio se o widget foi descartado
      return OverlayEntry(builder: (context) => const SizedBox.shrink());
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width - 40,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0.0, 50.0),
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
                      if (!widget.controller.showingSubClients) ...[
                        // Opção "Todos"
                        ListTile(
                          title: const Text(
                            "Todos",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            widget.controller.setFilterOption("Todos");
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
                              widget.controller.setFilterOption(client.name);
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
                            widget.controller.showAllClients();
                            widget.controller.setFilterOption("Todos");
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
    // Marca o widget como descartado antes de remover o overlay
    _isDisposed = true;
    _removeDropdownOverlay();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // Certifique-se de que qualquer overlay é removido quando as dependências mudam
    _removeDropdownOverlay();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
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
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.controller.showingSubClients
                    ? widget.controller.selectedClient!.name
                    : widget.controller.filterOption,
                style: const TextStyle(color: Colors.white),
              ),
              Icon(
                isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
