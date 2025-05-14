import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:intl/intl.dart';

class AnaliseComponent extends StatefulWidget {
  final CondominioModel condominio;

  const AnaliseComponent({super.key, required this.condominio});

  @override
  State<AnaliseComponent> createState() => _AnaliseComponentState();
}

class _AnaliseComponentState extends State<AnaliseComponent> {
  // Controladores para campos de data
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _finalController = TextEditingController();

  // Controle de visibilidade das séries
  final Map<String, bool> _seriesVisibility = {
    'cisterna_nivel': true,
    'cisterna_metro': true,
    'cisterna_volume': true,
    'reservatorio_nivel': true,
    'pressao_saida': true,
    'bomba1_li': true,
    'bomba2_li': true,
    'bateria': true,
  };

  final Map<String, Color> _seriesColors = {
    'cisterna_nivel': Colors.blue,
    'cisterna_metro': Colors.teal,
    'cisterna_volume': Colors.lightBlue,
    'reservatorio_nivel': const Color.fromARGB(255, 244, 111, 3),
    'pressao_saida': Colors.green,
    'bomba1_li': Colors.purple.withOpacity(0.5),
    'bomba2_li': Colors.deepPurple,
    'bateria': Colors.red,
  };

  // Labels para cada série
  final Map<String, String> _seriesLabels = {
    'cisterna_nivel': 'Cisterna 1',
    'cisterna_metro': 'Cisterna 2',
    'cisterna_volume': 'Cistern Volume',
    'reservatorio_nivel': 'Reservatório',
    'pressao_saida': 'Pressão',
    'bomba1_li': 'Bomba 1 Ligada',
    'bomba2_li': 'Bomba 2 Ligada',
    'bateria': 'Bateria',
  };

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();
  List<Map<String, dynamic>> _filteredHistorico = [];

  // Armazenar valores originais para mostrar corretamente nos tooltips
  Map<String, List<double>> _originalValues = {};

  @override
  void initState() {
    super.initState();

    // Inicializar controllers com datas padrão
    _inicioController.text = DateFormat('dd/MM/yyyy HH:mm').format(_startDate);
    _finalController.text = DateFormat('dd/MM/yyyy HH:mm').format(_endDate);

    // Filtrar dados históricos iniciais
    _filtrarHistorico();
  }

  @override
  void dispose() {
    _inicioController.dispose();
    _finalController.dispose();
    super.dispose();
  }

  void _filtrarHistorico() {
    if (widget.condominio.historico == null) {
      setState(() {
        _filteredHistorico = [];
      });
      return;
    }

    setState(() {
      _filteredHistorico =
          widget.condominio.historico!.where((registro) {
            // Converter a string de data para DateTime
            final dataRegistro = DateTime.tryParse(registro['data_hora']);
            if (dataRegistro == null) return false;

            // Verificar se está dentro do intervalo selecionado
            return dataRegistro.isAfter(_startDate) &&
                dataRegistro.isBefore(_endDate.add(const Duration(days: 1)));
          }).toList();

      // Ordenar por data
      _filteredHistorico.sort((a, b) {
        final dateA = DateTime.tryParse(a['data_hora']) ?? DateTime(1970);
        final dateB = DateTime.tryParse(b['data_hora']) ?? DateTime(1970);
        return dateA.compareTo(dateB);
      });
    });
  }

  Future<void> _selecionarData(BuildContext context, bool isInicio) async {
    final controller = isInicio ? _inicioController : _finalController;
    final initialDate = isInicio ? _startDate : _endDate;

    // Selecionar data
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null) {
      // Selecionar hora
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        // Combinar data e hora
        final newDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Atualizar controller e variável de estado
        setState(() {
          controller.text = DateFormat('dd/MM/yyyy HH:mm').format(newDateTime);
          if (isInicio) {
            _startDate = newDateTime;
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  void _realizarBusca() {
    _filtrarHistorico();
  }

  void _toggleSeries(String series) {
    setState(() {
      _seriesVisibility[series] = !(_seriesVisibility[series] ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Envolver todo o conteúdo em um SingleChildScrollView para permitir rolagem
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              "Histórico",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Gráfico
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Botão Ampliar (apenas visual)
                    Row(
                      children: [
                        const Icon(Icons.show_chart, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          "Gráfico",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),

                    const Divider(),

                    // Gráfico principal
                    SizedBox(height: 300, child: _buildChart()),

                    const Divider(),

                    // Legenda
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children:
                          _seriesLabels.entries
                              .where(
                                (entry) =>
                                    _getAvailableSeries().contains(entry.key),
                              )
                              .map(
                                (entry) => _buildLegendItem(
                                  entry.key,
                                  entry.value,
                                  _seriesColors[entry.key] ?? Colors.grey,
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Período de consulta
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Período da Consulta",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campos de data
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Início"),
                              const SizedBox(height: 8),
                              _buildDateField(_inicioController, true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Final"),
                              const SizedBox(height: 8),
                              _buildDateField(_finalController, false),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _realizarBusca,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B4B65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Buscar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDateField(TextEditingController controller, bool isInicio) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selecionarData(context, isInicio),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
      ),
    );
  }

  Widget _buildLegendItem(String series, String label, Color color) {
    final isVisible = _seriesVisibility[series] ?? true;

    return InkWell(
      onTap: () => _toggleSeries(series),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isVisible ? color : Colors.grey.shade300,
              shape:
                  series.contains('bomba')
                      ? BoxShape.rectangle
                      : BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isVisible ? Colors.black87 : Colors.grey,
              decoration: isVisible ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getAvailableSeries() {
    final List<String> available = [];

    if (_filteredHistorico.isEmpty) return available;

    // Verificar quais séries estão disponíveis nos dados
    final firstRecord = _filteredHistorico.first;

    if (firstRecord.containsKey('cisterna_nivel')) {
      available.add('cisterna_nivel');
    }
    if (firstRecord.containsKey('cisterna_metro')) {
      available.add('cisterna_metro');
    }
    if (firstRecord.containsKey('cisterna_volume')) {
      available.add('cisterna_volume');
    }
    if (firstRecord.containsKey('reservatorio_nivel')) {
      available.add('reservatorio_nivel');
    }
    if (firstRecord.containsKey('pressao_saida')) {
      available.add('pressao_saida');
    }
    if (firstRecord.containsKey('bomba1_li')) available.add('bomba1_li');

    if (firstRecord.containsKey('bateria')) available.add('bateria');

    return available;
  }

  Widget _buildChart() {
    if (_filteredHistorico.isEmpty) {
      return const Center(
        child: Text(
          "Sem dados históricos para o período selecionado",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    final availableSeries = _getAvailableSeries();

    // Preparar os valores originais para uso nos tooltips
    _prepareOriginalValues(availableSeries);

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final seriesName = availableSeries[spot.barIndex];
                final label = _seriesLabels[seriesName] ?? seriesName;

                // Obter o valor original para mostrar no tooltip
                String valueDisplay;
                if (spot.spotIndex < _originalValues[seriesName]!.length) {
                  final originalValue =
                      _originalValues[seriesName]![spot.spotIndex];

                  if (seriesName.contains('bomba') ||
                      seriesName.contains('li')) {
                    valueDisplay = originalValue > 0 ? "Ligado" : "Desligado";
                  } else if (seriesName.contains('nivel')) {
                    // Mostrar como percentual
                    valueDisplay =
                        "${(originalValue * 100).toStringAsFixed(0)}%";
                  } else {
                    // Mostrar com 2 casas decimais
                    valueDisplay = originalValue.toStringAsFixed(2);
                  }
                } else {
                  valueDisplay = spot.y.toStringAsFixed(2);
                }

                return LineTooltipItem(
                  '$label: $valueDisplay',
                  TextStyle(color: _seriesColors[seriesName]),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 0.2,
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Mostrar os valores do eixo Y como percentuais
                return Text(
                  "${(value * 100).toInt()}%",
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= _filteredHistorico.length) {
                  return const SizedBox.shrink();
                }

                // Mostrar apenas algumas datas para evitar sobreposição
                if (value.toInt() % (_filteredHistorico.length ~/ 5) != 0) {
                  return const SizedBox.shrink();
                }

                final index = value.toInt();
                if (index < _filteredHistorico.length) {
                  final dataHora = DateTime.tryParse(
                    _filteredHistorico[index]['data_hora'],
                  );

                  if (dataHora != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('HH:mm').format(dataHora),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                }

                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: _filteredHistorico.length - 1.0,
        minY: 0,
        maxY: 1, // Para normalizar valores
        lineBarsData: _buildLineBarsData(availableSeries),
      ),
    );
  }

  // Preparar os valores originais para uso nos tooltips
  void _prepareOriginalValues(List<String> availableSeries) {
    _originalValues = {};

    for (final series in availableSeries) {
      _originalValues[series] = [];

      for (final item in _filteredHistorico) {
        if (item.containsKey(series)) {
          final rawValue = item[series];

          if (rawValue is bool) {
            _originalValues[series]!.add(rawValue ? 1.0 : 0.0);
          } else if (rawValue is num) {
            _originalValues[series]!.add(rawValue.toDouble());
          } else {
            _originalValues[series]!.add(0.0);
          }
        } else {
          _originalValues[series]!.add(0.0);
        }
      }
    }
  }

  List<LineChartBarData> _buildLineBarsData(List<String> availableSeries) {
    final List<LineChartBarData> result = [];

    // Adicionar apenas séries visíveis
    for (final series in availableSeries) {
      if (_seriesVisibility[series] == true) {
        result.add(_buildLineForSeries(series));
      }
    }

    return result;
  }

  LineChartBarData _buildLineForSeries(String series) {
    final spots = <FlSpot>[];

    // Normalizar valores para o gráfico
    double maxValue = 1.0;
    if (!series.contains('bomba') && !series.contains('li')) {
      // Encontrar valor máximo para normalização (exceto para séries booleanas)
      maxValue = _filteredHistorico.fold(0.0, (prev, item) {
        final value =
            item[series] is num ? (item[series] as num).toDouble() : 0.0;
        return value > prev ? value : prev;
      });

      // Se o valor máximo for 0, use 1 para evitar divisão por zero
      if (maxValue == 0) maxValue = 1.0;
    }

    // Criar spots para o gráfico
    for (int i = 0; i < _filteredHistorico.length; i++) {
      final item = _filteredHistorico[i];
      double yValue = 0;

      if (item.containsKey(series)) {
        final rawValue = item[series];

        if (rawValue is bool) {
          // Valores booleanos vão para 0 (false) ou 1 (true)
          yValue = rawValue ? 1.0 : 0.0;
        } else if (rawValue is num) {
          // Normalizar valores numéricos
          yValue = (rawValue / maxValue).clamp(0.0, 1.0);
        }
      }

      spots.add(FlSpot(i.toDouble(), yValue));
    }

    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: _seriesColors[series],
      barWidth: series.contains('bomba') ? 8 : 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: _seriesColors[series]?.withOpacity(0.1),
      ),
    );
  }
}
