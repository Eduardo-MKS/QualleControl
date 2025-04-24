import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/condominio_model.dart';

class AnaliseComponent extends StatefulWidget {
  final CondominioModel condominio;

  const AnaliseComponent({super.key, required this.condominio});

  @override
  State<AnaliseComponent> createState() => _AnaliseComponentState();
}

class _AnaliseComponentState extends State<AnaliseComponent> {
  DateTime _dataInicio = DateTime.now().subtract(const Duration(hours: 24));
  DateTime _dataFim = DateTime.now();
  List<HistoricoNivel> _historico = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Aqui você chamaria sua API para obter os dados históricos
      // Exemplo: _historico = await HistoricoService.obterHistorico(widget.condominio.id, _dataInicio, _dataFim);

      // Dados mockados para demonstração
      _historico = _gerarDadosMock(_dataInicio, _dataFim);
    } catch (e) {
      // Tratamento de erro
      print('Erro ao carregar histórico: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<HistoricoNivel> _gerarDadosMock(DateTime inicio, DateTime fim) {
    List<HistoricoNivel> dados = [];
    DateTime atual = inicio;

    while (atual.isBefore(fim)) {
      dados.add(
        HistoricoNivel(
          data: atual,
          nivel:
              50 +
              (DateTime.now().millisecondsSinceEpoch %
                      atual.millisecondsSinceEpoch) %
                  40,
        ),
      );
      atual = atual.add(const Duration(hours: 1));
    }

    return dados;
  }

  @override
  Widget build(BuildContext context) {
    // Calcular valores mínimo, médio e máximo
    double nivelMinimo = 0;
    double nivelMedio = 0;
    double nivelMaximo = 0;

    if (_historico.isNotEmpty) {
      nivelMinimo = _historico
          .map((h) => h.nivel)
          .reduce((a, b) => a < b ? a : b);
      nivelMaximo = _historico
          .map((h) => h.nivel)
          .reduce((a, b) => a > b ? a : b);
      nivelMedio =
          _historico.map((h) => h.nivel).reduce((a, b) => a + b) /
          _historico.length;
    } else {
      nivelMinimo = widget.condominio.nivelReservatorioPercentual ?? 0;
      nivelMedio = widget.condominio.nivelReservatorioPercentual ?? 0;
      nivelMaximo = widget.condominio.nivelReservatorioPercentual ?? 0;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Análise de Níveis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Período da consulta
                    _buildPeriodoConsulta(),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),

                    // Chart
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _historico.isEmpty
                        ? Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Sem dados para o período selecionado",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                        : SizedBox(height: 200, child: _buildLineChart()),

                    const SizedBox(height: 20),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          "Mínimo",
                          "${nivelMinimo.toStringAsFixed(1)}%",
                        ),
                        _buildStatItem(
                          "Médio",
                          "${nivelMedio.toStringAsFixed(1)}%",
                        ),
                        _buildStatItem(
                          "Máximo",
                          "${nivelMaximo.toStringAsFixed(1)}%",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Additional analysis card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tendências de Consumo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Implementar análise de tendências aqui
                    Text(
                      "Consumo diário médio: ${(nivelMaximo - nivelMinimo).toStringAsFixed(1)}%",
                    ),
                    const SizedBox(height: 10),
                    Text(
                      nivelMedio > 70
                          ? "Status: Nível bom"
                          : nivelMedio > 40
                          ? "Status: Nível moderado"
                          : "Status: Nível crítico",
                      style: TextStyle(
                        color:
                            nivelMedio > 70
                                ? Colors.green
                                : nivelMedio > 40
                                ? Colors.orange
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodoConsulta() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Período da Consulta",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Início"),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () => _selecionarData(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${_dataInicio.day.toString().padLeft(2, '0')}/${_dataInicio.month.toString().padLeft(2, '0')}/${_dataInicio.year} ${_dataInicio.hour.toString().padLeft(2, '0')}:${_dataInicio.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Final"),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () => _selecionarData(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${_dataFim.day.toString().padLeft(2, '0')}/${_dataFim.month.toString().padLeft(2, '0')}/${_dataFim.year} ${_dataFim.hour.toString().padLeft(2, '0')}:${_dataFim.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  _carregarHistorico();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Buscar"),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  // Função para exportar dados
                },
                child: const Text("Exportar"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selecionarData(bool isInicio) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: isInicio ? _dataInicio : _dataFim,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      final TimeOfDay? horaSelecionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isInicio ? _dataInicio : _dataFim),
      );

      if (horaSelecionada != null) {
        setState(() {
          final DateTime novaData = DateTime(
            dataSelecionada.year,
            dataSelecionada.month,
            dataSelecionada.day,
            horaSelecionada.hour,
            horaSelecionada.minute,
          );

          if (isInicio) {
            _dataInicio = novaData;
          } else {
            _dataFim = novaData;
          }
        });
      }
    }
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 25,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _calcularIntervaloX(),
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < _historico.length) {
                  final hora = _historico[value.toInt()].data.hour;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text('${hora}h'),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('${value.toInt()}%'),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: _historico.length - 1.0,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: _gerarSpots(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade800],
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade200.withOpacity(0.3),
                  Colors.blue.shade800.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blue.shade700,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final hora = _historico[spot.x.toInt()].data;
                final formattedHora =
                    "${hora.hour}:${hora.minute.toString().padLeft(2, '0')}";
                return LineTooltipItem(
                  "${spot.y.toStringAsFixed(1)}%\n$formattedHora",
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  double _calcularIntervaloX() {
    if (_historico.length <= 6) return 1;
    if (_historico.length <= 12) return 2;
    if (_historico.length <= 24) return 4;
    return (_historico.length / 6).ceil().toDouble();
  }

  List<FlSpot> _gerarSpots() {
    return List.generate(_historico.length, (index) {
      return FlSpot(index.toDouble(), _historico[index].nivel);
    });
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.blue, fontSize: 16)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Modelo de dados para o histórico
class HistoricoNivel {
  final DateTime data;
  final double nivel;

  HistoricoNivel({required this.data, required this.nivel});
}
