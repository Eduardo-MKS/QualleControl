import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';

class CondoCard extends StatelessWidget {
  final CondominioModel condominio;
  final VoidCallback onTap;

  // ignore: use_super_parameters
  const CondoCard({Key? key, required this.condominio, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(condominio.imageCondo), height: 200),
              const SizedBox(height: 8),
              Text(
                condominio.nome,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Toque para ver detalhes',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
