import 'package:flutter_mks_app/models/client_model.dart';
import 'package:flutter_mks_app/models/sub_client_model.dart';

final List<Client> allClients = [
  Client(
    id: '1',
    name: 'TITO',
    subClients: [SubClient(id: '1-1', name: 'PCH São Luís', clientId: '1')],
  ),
  Client(
    id: '2',
    name: 'CERAN',
    subClients: [
      SubClient(id: '2-1', name: 'CERAN - UHE 14 de Julho', clientId: '2'),
      SubClient(id: '2-2', name: 'CERAN - UHE Castro Alves', clientId: '2'),
      SubClient(id: '2-3', name: 'CERAN - UHE Monte Claro', clientId: '2'),
    ],
  ),
  Client(
    id: '3',
    name: 'CPFL',
    subClients: [
      SubClient(id: '3-1', name: 'CPFL - PCH Lucia Cherobim', clientId: '3'),
    ],
  ),
  Client(
    id: '4',
    name: 'DCSP',
    subClients: [
      SubClient(id: '4-1', name: 'DC SP - Capivari', clientId: '4'),
      SubClient(
        id: '4-2',
        name: 'DC SP - Ferraz de Vasconcelos',
        clientId: '4',
      ),
      SubClient(id: '4-3', name: 'DC SP - Francisco Morato', clientId: '4'),
      SubClient(
        id: '4-4',
        name: 'DC SP - São Luiz do Paraitinga',
        clientId: '4',
      ),
    ],
  ),
];
