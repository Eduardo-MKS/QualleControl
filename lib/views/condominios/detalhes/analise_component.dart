// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_mks_app/models/condominio_model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
    'reservatorio_nivel': true,
    'pressao_saida': true,
    'cisterna_nivel': true,
    'bateria': true,
    'bomba1_rpm': true,
    'bomba2_rpm': true,
    'vazao': true,
    'bomba1_corrente': true,
    'bateria_tensao': true,
    'reservatorio1_nivel': true,
    'reservatorio_bateria_v': true,
  };

  // Cores das séries
  final Map<String, Color> _seriesColors = {
    'reservatorio_nivel': const Color.fromARGB(255, 244, 111, 3),
    'pressao_saida': Colors.green,
    'cisterna_nivel': Colors.blue,
    'bateria': Colors.red,
    'bomba1_rpm': Colors.purple,
    'bomba2_rpm': const Color.fromARGB(255, 222, 33, 255),
    'vazao': const Color.fromARGB(255, 116, 21, 61),
    'corrente': const Color.fromARGB(255, 22, 255, 243),
    'bateria_tensao': const Color.fromARGB(255, 150, 82, 20),
    'bomba1_corrente': const Color.fromARGB(255, 133, 111, 255),
    'cisterna1_nivel': const Color.fromARGB(255, 84, 13, 197),
    'reservatorio1_nivel': const Color.fromARGB(255, 244, 111, 3),
    'reservatorio_bateria_v': const Color.fromARGB(255, 59, 212, 105),
  };

  // Labels para cada série
  final Map<String, String> _seriesLabels = {
    'cisterna_nivel': 'Cisterna 1',
    'reservatorio_nivel': 'Reservatório',
    'pressao_saida': 'Pressão',
    'bateria': 'Bateria',
    'bomba1_rpm': 'bomba1_rpm',
    'bomba2_rpm': 'bomba2_rpm',
    'vazao': 'Vazão',
    'corrente': 'Corrente',
    'bateria_tensao': 'Bateria',
    'bomba1_corrente': 'bomba1_corrente',
    'cisterna1_nivel': 'Cisterna 1',
    'reservatorio_bateria_v': 'Bateria',
  };

  // Valores máximos esperados para cada série (para evitar normalização excessiva)
  final Map<String, double> _seriesMaxValues = {
    'cisterna_nivel': 1.0,
    'reservatorio_nivel': 1.0,
    'pressao_saida': 10.0,
    'bateria': 100.0,
    'bomba1_rpm': 4000.0,
    'bomba2_rpm': 4000.0,
    'vazao': 10.0,
    'corrente': 10.0,
    'bateria_tensao': 10.0,
    'bomba1_corrente': 10.0,
    'cisterna1_nivel': 1.0,
    'reservatorio_bateria_v': 10.0,
  };

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();
  List<Map<String, dynamic>> _filteredHistorico = [];

  Map<String, List<double>> _originalValues = {};

  @override
  void initState() {
    super.initState();

    _inicioController.text = DateFormat('dd/MM/yyyy HH:mm').format(_startDate);
    _finalController.text = DateFormat('dd/MM/yyyy HH:mm').format(_endDate);

    _filtrarHistorico();
    print(_filteredHistorico);
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
            final dataRegistro = DateTime.tryParse(registro['data_hora']);
            if (dataRegistro == null) return false;

            return dataRegistro.isAfter(
                  _startDate.subtract(const Duration(seconds: 1)),
                ) &&
                dataRegistro.isBefore(_endDate.add(const Duration(seconds: 1)));
          }).toList();

      _filteredHistorico.sort((a, b) {
        final dateA = DateTime.tryParse(a['data_hora']) ?? DateTime(1970);
        final dateB = DateTime.tryParse(b['data_hora']) ?? DateTime(1970);
        return dateA.compareTo(dateB);
      });
    });

    print(
      'Período selecionado: ${DateFormat('dd/MM/yyyy HH:mm').format(_startDate)} até ${DateFormat('dd/MM/yyyy HH:mm').format(_endDate)}',
    );
    print('Registros filtrados: ${_filteredHistorico.length}');
    if (_filteredHistorico.isNotEmpty) {
      print('Primeiro registro: ${_filteredHistorico.first['data_hora']}');
      print('Último registro: ${_filteredHistorico.last['data_hora']}');
    }
  }

  Future<void> _selecionarData(BuildContext context, bool isInicio) async {
    final controller = isInicio ? _inicioController : _finalController;
    final initialDate = isInicio ? _startDate : _endDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final newDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
                    Row(
                      children: [
                        const Icon(Icons.show_chart, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          "Gráfico",
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),

                    const Divider(),
                    SizedBox(height: 350, child: _buildChart()),
                    const Divider(),

                    Wrap(
                      spacing: 20,
                      runSpacing: 12,
                      children:
                          _getAvailableSeries()
                              .map(
                                (seriesKey) => SizedBox(
                                  width: 120,
                                  child: _buildLegendItem(
                                    seriesKey,
                                    _seriesLabels[seriesKey] ?? seriesKey,
                                    _seriesColors[seriesKey] ?? Colors.grey,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Período da Consulta",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Início",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 1),
                              _buildDateField(_inicioController, true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Final",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 1),
                              _buildDateField(_finalController, false),
                            ],
                          ),
                        ),
                        const SizedBox(width: 1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                            child: Text(
                              "Buscar",
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
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
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                border: Border.all(color: Colors.black26, width: 1),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.quicksand(
                  color: isVisible ? Colors.black : Colors.grey,
                  decoration: isVisible ? null : TextDecoration.lineThrough,
                  fontWeight: isVisible ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getAvailableSeries() {
    final List<String> available = [];

    if (_filteredHistorico.isEmpty) return available;
    final firstRecord = _filteredHistorico.first;
    if (firstRecord.containsKey('cisterna_nivel'))
      available.add('cisterna_nivel');
    if (firstRecord.containsKey('bomba1_rpm')) available.add('bomba1_rpm');
    if (firstRecord.containsKey('bomba2_rpm')) available.add('bomba2_rpm');
    if (firstRecord.containsKey('reservatorio_nivel'))
      available.add('reservatorio_nivel');
    if (firstRecord.containsKey('pressao_saida'))
      available.add('pressao_saida');
    if (firstRecord.containsKey('bateria')) available.add('bateria');
    if (firstRecord.containsKey('vazao')) available.add('vazao');
    if (firstRecord.containsKey('corrente')) available.add('corrente');
    if (firstRecord.containsKey('bateria_tensao'))
      available.add('bateria_tensao');
    if (firstRecord.containsKey('bomba1_corrente'))
      available.add('bomba1_corrente');
    if (firstRecord.containsKey('cisterna1_nivel'))
      available.add('cisterna1_nivel');
    if (firstRecord.containsKey('reservatorio1_nivel'))
      available.add('reservatorio1_nivel');
    if (firstRecord.containsKey('reservatorio_bateria_v'))
      available.add('reservatorio_bateria_v');

    return available;
  }

  Widget _buildChart() {
    if (_filteredHistorico.isEmpty) {
      return const Center(
        child: Text(
          "Sem dados históricos para o período selecionado",
          style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
        ),
      );
    }
    final availableSeries = _getAvailableSeries();

    _prepareOriginalValues(availableSeries);
    final visibleSeries =
        availableSeries
            .where((series) => _seriesVisibility[series] == true)
            .toList();
    if (visibleSeries.isEmpty) {
      for (final series in availableSeries) {
        _seriesVisibility[series] = true;
      }
      visibleSeries.addAll(availableSeries);
    }

    double minY = 0;
    double maxY = 0.1;

    for (final series in visibleSeries) {
      for (final value in _originalValues[series] ?? []) {
        final normalizedValue = value / (_seriesMaxValues[series] ?? 1.0);

        if (normalizedValue > maxY) {
          maxY = normalizedValue;
        }
        if (normalizedValue < minY) {
          minY = normalizedValue;
        }
      }
    }

    maxY = (maxY * 1.1).clamp(0.0, 1.0);

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.9),
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final seriesName = visibleSeries[spot.barIndex];
                final label = _seriesLabels[seriesName] ?? seriesName;

                // Obter o valor original para mostrar no tooltip
                String valueDisplay;
                if (spot.spotIndex < _originalValues[seriesName]!.length) {
                  final originalValue =
                      _originalValues[seriesName]![spot.spotIndex];

                  // Para RPM das bombas, mostrar o valor numérico
                  if (seriesName.contains('bomba') &&
                      seriesName.contains('rpm')) {
                    valueDisplay = "${originalValue.toStringAsFixed(0)} RPM";
                  }
                  // Para outros status de bomba (ligado/desligado)
                  else if (seriesName.contains('bomba') ||
                      seriesName.contains('li')) {
                    valueDisplay = originalValue > 0 ? "Ligado" : "Desligado";
                  } else if (seriesName.contains('nivel')) {
                    // Mostrar como percentual
                    valueDisplay = (originalValue * 100).toStringAsFixed(0);
                  } else if (seriesName == 'bateria') {
                    valueDisplay = originalValue.toStringAsFixed(0);
                  } else if (seriesName == 'pressao_saida') {
                    valueDisplay = "${originalValue.toStringAsFixed(2)} ";
                  } else if (seriesName == 'vazao') {
                    valueDisplay = "${originalValue.toStringAsFixed(2)} ";
                  } else if (seriesName == 'bateria_tensao') {
                    valueDisplay = "${originalValue.toStringAsFixed(2)} ";
                  } else if (seriesName == 'bomba1_corrente') {
                    valueDisplay = "${originalValue.toStringAsFixed(2)} ";
                  } else if (seriesName == 'corrente') {
                    valueDisplay = "${originalValue.toStringAsFixed(2)} ";
                  } else if (seriesName == 'cisterna1_nivel') {
                    valueDisplay = "${originalValue.toStringAsFixed(2)} ";
                  } else if (seriesName == 'reservatorio1_nivel') {
                    valueDisplay = "${originalValue.toStringAsFixed(2)} ";
                  } else if (seriesName == 'reservatorio_bateria_v') {
                    valueDisplay = originalValue.toStringAsFixed(2);
                  } else {
                    // Mostrar com 2 casas decimais
                    valueDisplay = originalValue.toStringAsFixed(2);
                  }
                } else {
                  valueDisplay = "N/A";
                }

                return LineTooltipItem(
                  '$label: $valueDisplay',
                  TextStyle(
                    color: _seriesColors[seriesName] ?? Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 0.1, // Grid a cada 10%
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.15), // Grid mais sutil
              strokeWidth: 0.8,
              dashArray:
                  value % 0.2 == 0 ? null : [5, 5], // Linhas principais sólidas
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.1), // Grid mais sutil
              strokeWidth: 0.8,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Mostrar os valores do eixo Y como percentuais
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    "${(value * 100).toInt()}%",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
              reservedSize: 40,
              interval: 0.2, // Mostrar a cada 20%
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= _filteredHistorico.length) {
                  return const SizedBox.shrink();
                }

                // Calcular quantos pontos mostrar baseado no tamanho dos dados
                final interval = (_filteredHistorico.length / 5).ceil();
                if (value.toInt() % interval != 0) {
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
                          fontWeight: FontWeight.bold,
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
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ), // Borda mais sutil
        ),
        minX: 0,
        maxX: _filteredHistorico.length - 1.0,
        minY: minY,
        maxY: maxY,
        lineBarsData: _buildLineBarsData(
          visibleSeries,
        ), // Usar apenas séries visíveis
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

          // Para séries de RPM das bombas, sempre tratar como número
          if (series.contains('bomba') && series.contains('rpm')) {
            if (rawValue is num) {
              _originalValues[series]!.add(rawValue.toDouble());
            } else {
              // Se não for número, assumir 0 (bomba desligada)
              _originalValues[series]!.add(0.0);
            }
          }
          // Para outras séries booleanas (status de ligado/desligado)
          else if (rawValue is bool) {
            _originalValues[series]!.add(rawValue ? 1.0 : 0.0);
          }
          // Para valores numéricos em geral
          else if (rawValue is num) {
            _originalValues[series]!.add(rawValue.toDouble());
          }
          // Valor padrão
          else {
            _originalValues[series]!.add(0.0);
          }
        } else {
          _originalValues[series]!.add(0.0);
        }
      }
    }
  }

  List<LineChartBarData> _buildLineBarsData(List<String> visibleSeries) {
    final List<LineChartBarData> result = [];

    for (int i = 0; i < visibleSeries.length; i++) {
      final series = visibleSeries[i];
      result.add(_buildLineForSeries(series, i));
    }

    return result;
  }

  LineChartBarData _buildLineForSeries(String series, int index) {
    final spots = <FlSpot>[];

    // Usar o valor máximo pré-definido para normalização
    final maxValue = _seriesMaxValues[series] ?? 1.0;

    // Criar spots para o gráfico
    for (int i = 0; i < _filteredHistorico.length; i++) {
      final item = _filteredHistorico[i];
      double yValue = 0;

      if (item.containsKey(series)) {
        final rawValue = item[series];

        // Para séries de RPM das bombas, sempre tratar como número
        if (series.contains('bomba') && series.contains('rpm')) {
          if (rawValue is num) {
            // Normalizar valores numéricos com base no valor máximo pré-definido
            yValue = (rawValue / maxValue).clamp(0.0, 1.0);
          } else {
            // Se não for número, assumir 0 (bomba desligada)
            yValue = 0.0;
          }
        }
        // Para outras séries booleanas (status de ligado/desligado)
        else if (rawValue is bool) {
          // Valores booleanos vão para 0 (false) ou 1 (true)
          yValue = rawValue ? 1.0 : 0.0;
        }
        // Para valores numéricos em geral
        else if (rawValue is num) {
          // Normalizar valores numéricos com base no valor máximo pré-definido
          yValue = (rawValue / maxValue).clamp(0.0, 1.0);
        }
      }

      spots.add(FlSpot(i.toDouble(), yValue));
    }

    final bool isBomba = series.contains('bomba') || series.contains('li');

    return LineChartBarData(
      spots: spots,
      isCurved: !isBomba, // Curvas suaves para tudo exceto bombas
      curveSmoothness: 0.2,
      color: _seriesColors[series],
      barWidth: isBomba ? 2 : 2.5, // Linha mais fina para bombas
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false, // Não mostrar pontos
      ),
      belowBarData: BarAreaData(
        show: false,
        spotsLine: BarAreaSpotsLine(show: false),
      ),
    );
  }
}
