import 'package:flutter/material.dart';
import 'package:flutter_mks_app/models/client_model.dart';
import 'package:flutter_mks_app/models/sub_client_model.dart';
import 'package:flutter_mks_app/models/clients_data.dart';

class ClientController extends ChangeNotifier {
  List<Client> filteredClients = [];
  TextEditingController searchController = TextEditingController();

  bool showingSubClients = false;
  Client? selectedClient;
  List<SubClient> currentSubClients = [];

  String filterOption = "Todos";

  ClientController() {
    filteredClients = List.from(allClients);
    searchController.addListener(() {
      filterClients();
    });
  }

  void filterClients() {
    if (searchController.text.isEmpty) {
      filteredClients = List.from(allClients);
    } else {
      filteredClients =
          allClients
              .where(
                (client) => client.name.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
    }
    notifyListeners();
  }

  void showSubClients(Client client) {
    showingSubClients = true;
    selectedClient = client;
    currentSubClients = client.subClients;
    notifyListeners();
  }

  void showAllClients() {
    showingSubClients = false;
    selectedClient = null;
    notifyListeners();
  }

  void setFilterOption(String option) {
    filterOption = option;
    if (option == "Todos") {
      filteredClients = List.from(allClients);
    } else {
      filteredClients =
          allClients.where((client) => client.name == option).toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
