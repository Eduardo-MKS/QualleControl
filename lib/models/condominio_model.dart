class CondominioModel {
  final String nome;
  final double? nivelReservatorioPercentual;
  final String? nivelReservatorioMetros;
  final DateTime? ultimaAtualizacao;
  final String? imageCondo;
  final bool hasCisterna;
  final double? nivelCisternaPercentual;
  final String? nivelCisternaMetros;
  final bool hasPressao;
  final double? pressaoSaida;
  final bool hasGeral;
  final String? energia;
  final String? boia;
  final String? bateria;
  final String? operacao;
  final bool hasVazao;
  final String? vazao;
  final String? totalizador;

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
    this.vazao,
    this.hasGeral = false,
    this.hasVazao = false,
    this.totalizador,
  });

  factory CondominioModel.fromJson(Map<String, dynamic> json) {
    final informacoes = json['informacoes'] ?? {};
    final reservatorioList = informacoes['reservatorio'] as List? ?? [];
    final cisternaList = informacoes['cisterna'] as List? ?? [];
    final casaDeBombas = informacoes['casaDeBombas'] ?? {};

    final reservatorio =
        reservatorioList.isNotEmpty ? reservatorioList[0] : null;
    final cisterna = cisternaList.isNotEmpty ? cisternaList[0] : null;

    String imageAsset = 'assets/prédios_Prancheta.png';
    if (json["nome"] == 'Condomínio Quinta Das Palmeiras') {
      imageAsset = 'assets/casas.png';
    }

    // Parse energia, remoto, bateria, boia
    final bool? energiaStatus = casaDeBombas['energia'];
    final bool? remotoStatus = casaDeBombas['remoto'];
    final num? bateriaValue = casaDeBombas['bateria']?['tensao'];
    final bool? boiaStatus = cisterna?['boia'];

    return CondominioModel(
      nome: json['nome'] ?? '',
      ultimaAtualizacao: DateTime.tryParse(json['ultimaAtualizacao'] ?? ''),
      nivelReservatorioMetros:
          reservatorio?['nivelMetro'] != null
              ? (reservatorio['nivelMetro'] as num).toStringAsFixed(2)
              : null,
      nivelReservatorioPercentual:
          (reservatorio?['nivelPercentual'] as num?)?.toDouble(),
      nivelCisternaMetros:
          cisterna?['nivelMetro'] != null
              ? (cisterna['nivelMetro'] as num).toStringAsFixed(2)
              : null,
      nivelCisternaPercentual:
          (cisterna?['nivelPercentual'] as num?)?.toDouble(),
      imageCondo: imageAsset,
      hasCisterna: cisterna != null,
      hasPressao: cisterna?['pressao']?['saida'] != null,
      pressaoSaida: (cisterna?['pressao']?['saida'] as num?)?.toDouble(),
      hasGeral:
          energiaStatus != null ||
          remotoStatus != null ||
          bateriaValue != null ||
          boiaStatus != null,
      energia: energiaStatus?.toString(),
      boia: boiaStatus?.toString(),
      bateria: bateriaValue?.toStringAsFixed(2),
      operacao: remotoStatus?.toString(),
      hasVazao: false,
      totalizador: (cisterna?["totalizador"] as num?)?.toStringAsFixed(2),
      vazao: (cisterna?["vazao"] as num?)?.toStringAsFixed(2),
    );
  }
}
