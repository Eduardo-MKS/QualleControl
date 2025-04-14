import 'package:flutter/material.dart';
import 'package:flutter_mks_app/views/azas/home_azas.dart';
import 'package:flutter_mks_app/views/condominios/condominios_home.dart';
import 'package:flutter_mks_app/views/hidrometeorologia/home_hidro.dart';
import 'package:flutter_mks_app/views/home_page.dart';
import 'package:flutter_mks_app/views/login_page.dart';
import 'package:flutter_mks_app/views/saneamento/home_sanea.dart';
import 'package:flutter_mks_app/views/teste_page.dart';

main() {
  runApp(MyApp());
} //o que este cara faz: chama a função MyApp que é a nossa aplicação

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 40, 73, 163)),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginPage(),
        '/home': (_) => const HomePage(),
        '/teste': (_) => const TestePage(),
        '/azas': (_) => const azazHome(),
        '/condominios': (_) => const condoHome(),
        '/hidrometeorologia': (_) => const HomeHidro(),
        '/saneamento': (_) => const SaneaScreen(),
      },
    );
  }
}
