class CondominioModel {
  final String nome;
  final double nivelReservatorioPercentual;
  final double nivelReservatorioMetros;
  final DateTime ultimaAtualizacao;
  final String imageCondo;

  // New fields
  final bool hasCisterna;
  final double? nivelCisternaPercentual;
  final double? nivelCisternaMetros;
  final bool hasPressao;
  final double? pressaoSaida;

  CondominioModel({
    required this.nome,
    required this.nivelReservatorioPercentual,
    required this.nivelReservatorioMetros,
    required this.ultimaAtualizacao,
    required this.imageCondo,
    this.hasCisterna = false,
    this.nivelCisternaPercentual,
    this.nivelCisternaMetros,
    this.hasPressao = false,
    this.pressaoSaida,
  });
}
