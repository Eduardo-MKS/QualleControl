import 'package:flutter/material.dart';

class FilterSidebar extends StatelessWidget {
  final VoidCallback onClose;

  const FilterSidebar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
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
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Spacer(),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Spacer(),
                      const SizedBox(child: Text('Desenvolvido por')),
                      const SizedBox(height: 8),
                      const SizedBox(
                        child: Image(
                          image: AssetImage('assets/ehoteste.png'),
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
