class CondominioModel {
  final String nome;
  final double? nivelReservatorioPercentual;
  final String? nivelReservatorioMetros;
  final DateTime? ultimaAtualizacao;
  final String? imageCondo;
  final bool hasCisterna;
  final double? nivelCisternaPercentual;
  final double? nivelCisternaMetros;
  final bool hasPressao;
  final double? pressaoSaida;
  final String? energia;
  final String? boia;
  final String? bateria;
  final String? operacao;

  CondominioModel({
    required this.nome,
    this.nivelReservatorioPercentual,
    this.nivelReservatorioMetros,
    this.ultimaAtualizacao,
    this.imageCondo,
    this.hasCisterna = false,
    this.nivelCisternaPercentual,
    this.nivelCisternaMetros,
    this.hasPressao = false,
    this.pressaoSaida,
    this.energia,
    this.boia,
    this.bateria,
    this.operacao,
  });

  factory CondominioModel.fromJson(Map<String, dynamic> json) {
    final informacoes = json['informacoes'] ?? {};
    final reservatorioList = informacoes['reservatorio'] as List? ?? [];
    final cisternaList = informacoes['cisterna'] as List? ?? [];

    final reservatorio =
        reservatorioList.isNotEmpty ? reservatorioList[0] : null;
    final cisterna = cisternaList.isNotEmpty ? cisternaList[0] : null;

    String imageAsset = 'assets/prédios_Prancheta.png';
    if (json["nome"] == 'Condomínio Quinta Das Palmeiras') {
      imageAsset = 'assets/casas.png';
    }

    return CondominioModel(
      nome: json['nome'] ?? '',
      ultimaAtualizacao: DateTime.tryParse(json['ultimaAtualizacao'] ?? ''),
      nivelReservatorioMetros:
          (reservatorio?['nivelMetro'] as num?)?.toStringAsFixed(2) ?? '',
      nivelReservatorioPercentual:
          (reservatorio?['nivelPercentual'] as num?)?.toDouble(),
      nivelCisternaMetros: (cisterna?['nivelMetro'] as num?)?.toDouble(),
      nivelCisternaPercentual:
          (cisterna?['nivelPercentual'] as num?)?.toDouble(),
      imageCondo: imageAsset, // Imagem fixa
      hasCisterna: cisterna != null,
      hasPressao: false, // Se não existir no JSON, setar como false
      pressaoSaida: null,
      energia: null, // Adapte se necessário
      boia: null,
      bateria:
          (reservatorio?['painelReservatorio']?['bateria']?['tensao'] as num?)
              ?.toString(),
      operacao: null,
    );
  }
}
