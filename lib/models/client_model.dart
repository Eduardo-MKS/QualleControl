import 'package:flutter_mks_app/models/sub_client_model.dart';

class Client {
  final String id;
  final String name;
  final List<SubClient> subClients;

  Client({required this.id, required this.name, this.subClients = const []});
}
