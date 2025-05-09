import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/qualle_control.svg', height: 50),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: ListTile(
                    leading: Image.asset('assets/simbolo-azas.png', height: 40),
                    title: Text(
                      'qualle control',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'A-ZAS',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right_alt_sharp),
                    onTap: () {
                      Navigator.pushNamed(context, '/azas');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: ListTile(
                    leading: Image.asset('assets/simbolo-cond.png', height: 40),
                    title: Text(
                      'qualle control',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Condomínios',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right_alt_sharp),
                    onTap: () {
                      Navigator.pushNamed(context, '/condominios');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: ListTile(
                    title: Text(
                      'qualle control',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Hidrometeorologia',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/simbolo-hidro.png',
                      height: 40,
                    ),
                    trailing: Icon(Icons.arrow_right_alt_sharp),
                    onTap: () {
                      Navigator.pushNamed(context, '/hidrometeorologia');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: ListTile(
                    title: Text(
                      'qualle control',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Saneamento',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/simbolo-sanea.png',
                      height: 40,
                    ),
                    trailing: Icon(Icons.arrow_right_alt_sharp),
                    onTap: () {
                      Navigator.pushNamed(context, '/saneamento');
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Desenvolvido por: '),
                    Text(
                      'MKS',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 37, 58, 151),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: null),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (route) => false);
                      },
                      child: const Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
