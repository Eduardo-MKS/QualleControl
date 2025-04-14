import 'package:flutter/material.dart';

// ignore: camel_case_types
class azazHome extends StatelessWidget {
  const azazHome({super.key});

  static const _login = 'Admin';

  @override
  Widget build(BuildContext context) {
    return Text('Olá $_login', style: const TextStyle(fontSize: 30));
  }
}
