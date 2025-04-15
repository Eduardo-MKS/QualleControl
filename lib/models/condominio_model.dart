class CondominioModel {
  final String nome;
  final double nivelReservatorioPercentual;
  final double nivelReservatorioMetros;
  final DateTime ultimaAtualizacao;
  final String imageCondo;

  CondominioModel({
    required this.nome,
    required this.nivelReservatorioPercentual,
    required this.nivelReservatorioMetros,
    required this.ultimaAtualizacao,
    required this.imageCondo,
  });
}
