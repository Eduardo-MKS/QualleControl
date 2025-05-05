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
  final String? pressaoSaida;
  final bool hasGeral;
  final String? energia;
  final String? boia;
  final String? bateria;
  final String? operacao;
  final bool hasVazao;
  final String? vazao;
  final String? totalizador;
  final bool hasPainelReservatorio;
  final bool sirene;
  final bool? painelEnergia;
  final String? painelBateria;
  final bool? painelLed;
  final bool? painelSirene;
  final bool hasPainelCisterna;
  final String? painelCisternaBateria;
  final bool? painelCisternaLed;
  final bool? painelCisternaSirene;

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
    this.hasPainelReservatorio = false,
    this.sirene = false,
    this.painelEnergia,
    this.painelBateria,
    this.painelLed,
    this.painelSirene,
    this.hasPainelCisterna = false,
    this.painelCisternaBateria,
    this.painelCisternaLed,
    this.painelCisternaSirene,
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

    // Dados do painel do reservatório
    final painelReservatorio = reservatorio?['painelReservatorio'] ?? {};
    final bool temPainelReservatorio = painelReservatorio.isNotEmpty;
    final bool? painelEnergiaStatus = painelReservatorio['energia'];
    final dynamic painelBateriaValue = painelReservatorio['bateria'];
    final bool? painelLedStatus = painelReservatorio['led'];
    final bool? painelSireneStatus = painelReservatorio['sirene'];

    // Dados do painel da cisterna - Nova implementação
    final painelCisterna = cisterna?['PainelCisterna'] ?? {};
    final bool temPainelCisterna = painelCisterna.isNotEmpty;
    final dynamic painelCisternaBateriaValue = painelCisterna['bateria'];
    final bool? painelCisternaLedStatus = painelCisterna['led'];
    final bool? painelCisternaSireneStatus = painelCisterna['sirene'];

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
      pressaoSaida: (cisterna?['pressao']?['saida'] as num?)?.toStringAsFixed(
        2,
      ),
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
      hasPainelReservatorio: temPainelReservatorio,
      sirene: painelSireneStatus ?? false,
      painelEnergia: painelEnergiaStatus,
      painelBateria:
          painelBateriaValue != null
              ? (painelBateriaValue is num
                  ? painelBateriaValue.toStringAsFixed(2)
                  : painelBateriaValue.toString())
              : null,
      painelLed: painelLedStatus,
      painelSirene: painelSireneStatus,
      hasPainelCisterna: temPainelCisterna,
      painelCisternaBateria:
          painelCisternaBateriaValue?['tensao'] != null
              ? (painelCisternaBateriaValue['tensao'] as num).toStringAsFixed(2)
              : null,
      painelCisternaLed: painelCisternaLedStatus,
      painelCisternaSirene: painelCisternaSireneStatus,
    );
  }
}
