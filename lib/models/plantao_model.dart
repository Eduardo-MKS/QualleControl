class PlantaoResponse {
  final PlantaoAtual? sobreavisoAtual;

  PlantaoResponse({this.sobreavisoAtual});

  factory PlantaoResponse.fromJson(Map<String, dynamic> json) {
    return PlantaoResponse(
      sobreavisoAtual:
          json['data']?['sobreavisoAtual'] != null
              ? PlantaoAtual.fromJson(json['data']['sobreavisoAtual'])
              : null,
    );
  }
}

class PlantaoAtual {
  final String? id;
  final DateTime? dataInicio;
  final DateTime? dataFinal;
  final List<Contato>? contatoCampo;
  final List<Contato>? contatoSuporte;

  PlantaoAtual({
    this.id,
    this.dataInicio,
    this.dataFinal,
    this.contatoCampo,
    this.contatoSuporte,
  });

  factory PlantaoAtual.fromJson(Map<String, dynamic> json) {
    return PlantaoAtual(
      id: json['id'],
      dataInicio: DateTime.tryParse(json['dataInicio'] ?? ''),
      dataFinal: DateTime.tryParse(json['dataFinal'] ?? ''),
      contatoCampo:
          (json['contatoCampo'] as List?)
              ?.map((e) => Contato.fromJson(e))
              .toList(),
      contatoSuporte:
          (json['contatoSuporte'] as List?)
              ?.map((e) => Contato.fromJson(e))
              .toList(),
    );
  }
}

class Contato {
  final String? id;
  final String? nome;
  final String? telefone;
  final String? origem;

  Contato({this.id, this.nome, this.telefone, this.origem});

  factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      origem: json['origem'],
    );
  }
}
