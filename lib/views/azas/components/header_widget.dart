import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              const Image(image: AssetImage('assets/ehoteste.png'), height: 15),
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
    );
  }
}
