import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';

class BombasCard extends StatelessWidget {
  final String titulo;

  final CondominioModel condominio;

  const BombasCard({super.key, required this.titulo, required this.condominio});

  @override
  Widget build(BuildContext context) {
    final bombas = condominio.bombas ?? [];

    final bomba1 = bombas.firstWhere(
      (bomba) => bomba['id'] == 1,
      orElse:
          () => {
            'bombaLigada': false,
            'rpm': 0,
            'corrente': 0.0,
            'consumo': 0,
            'horimetro': 0,
            'modo': false,
            'supervisorio': false,
          },
    );

    final bomba2 = bombas.firstWhere(
      (bomba) => bomba['id'] == 2,
      orElse:
          () => {
            'bombaLigada': false,
            'rpm': 0,
            'corrente': 0.0,
            'consumo': 0,
            'horimetro': 0,
            'modo': false,
            'supervisorio': false,
          },
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bomba 1
                Expanded(
                  child: _buildBombaInfo(
                    context,
                    'Bomba 1',
                    bomba1['bombaLigada'] == true,
                    bomba1['rpm'] != null ? bomba1['rpm'].toString() : '0',
                    bomba1['corrente'] != null
                        ? bomba1['corrente'].toStringAsFixed(2)
                        : '0.0',
                    'bomb1.png',
                    true,
                  ),
                ),
                Container(
                  height: 180,
                  width: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                // Bomba 2
                Expanded(
                  child: _buildBombaInfo(
                    context,
                    'Bomba 2',
                    bomba2['bombaLigada'] == true,
                    bomba2['rpm'] != null ? bomba2['rpm'].toString() : '0',
                    bomba2['corrente'] != null
                        ? bomba2['corrente'].toStringAsFixed(2)
                        : '0.0',
                    'bomb1.png',
                    false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBombaInfo(
    BuildContext context,
    String label,
    bool isActive,
    String rpm,
    String corrente,
    String imageName,
    bool esquerda,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Image.asset('assets/bomb1.png', height: 60),
          const SizedBox(height: 10),
          Text(
            '$rpm RPM',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            '$corrente A',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
