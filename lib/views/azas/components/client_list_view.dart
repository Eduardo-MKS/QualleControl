import 'package:flutter/material.dart';

import 'package:flutter_mks_app/controller/client_controller.dart';

class ClientListView extends StatelessWidget {
  final ClientController controller;

  // ignore: use_super_parameters
  const ClientListView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: controller.filteredClients.length,
      separatorBuilder:
          (context, index) => const Divider(color: Colors.grey, height: 1),
      itemBuilder: (context, index) {
        final client = controller.filteredClients[index];
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
            controller.showSubClients(client);
          },
        );
      },
    );
  }
}
