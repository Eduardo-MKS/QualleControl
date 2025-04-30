import 'package:flutter/material.dart';

class ReservatorioChart extends StatelessWidget {
  final double nivelPercentual;

  // ignore: use_super_parameters
  const ReservatorioChart({Key? key, required this.nivelPercentual})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          // Fundo do gráfico (representando a capacidade total)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 128, 128, 128),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Preenchimento do nível atual
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 160 * (nivelPercentual / 100),
              decoration: BoxDecoration(
                color: const Color.fromARGB(76, 0, 60, 255),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ),

          // Marcador de "Cota Bombeiros"
          /* Positioned(
            top: 50,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Cota Bombeiros",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
