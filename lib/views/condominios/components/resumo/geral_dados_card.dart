import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CisternaChart extends StatelessWidget {
  final List<Map<String, dynamic>> historicoData;
  final String title;

  const CisternaChart({
    Key? key,
    required this.historicoData,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtrar apenas os dados das últimas 24 horas
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(hours: 24));

    final filteredData =
        historicoData.where((entry) {
          final dataHora = DateTime.parse(entry['data_hora']);
          return dataHora.isAfter(yesterday) && dataHora.isBefore(now);
        }).toList();

    // Ordenar por data (do mais antigo para o mais recente)
    filteredData.sort((a, b) {
      final dateA = DateTime.parse(a['data_hora']);
      final dateB = DateTime.parse(b['data_hora']);
      return dateA.compareTo(dateB);
    });

    if (filteredData.isEmpty) {
      return _buildEmptyCard(
        title,
        'Sem dados disponíveis para as últimas 24 horas',
      );
    }

    // Converter para pontos do gráfico
    final List<FlSpot> spots = [];
    for (int i = 0; i < filteredData.length; i++) {
      double? nivelCisterna;

      if (filteredData[i].containsKey('cisterna_nivel')) {
        nivelCisterna = (filteredData[i]['cisterna_nivel'] as num?)?.toDouble();
      } else if (filteredData[i].containsKey('reservatorio_nivel')) {
        nivelCisterna =
            (filteredData[i]['reservatorio_nivel'] as num?)?.toDouble();
      } else if (filteredData[i].containsKey('nivelPercentual')) {
        nivelCisterna =
            (filteredData[i]['nivelPercentual'] as num?)?.toDouble();
      }

      if (nivelCisterna != null) {
        final nivelPercent = nivelCisterna * 100;
        spots.add(FlSpot(i.toDouble(), nivelPercent.roundToDouble()));
      }
    }

    if (spots.isEmpty) {
      return _buildEmptyCard(
        title,
        'Dados de nível não disponíveis para exibição no gráfico',
      );
    }

    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    minY = (minY - 5).clamp(0, 100);
    maxY = (maxY + 5).clamp(0, 100);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Últimas 24 horas',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval:
                        spots.length > 6
                            ? (spots.length / 6).ceil().toDouble()
                            : 1,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval:
                            spots.length > 6
                                ? (spots.length / 6).ceil().toDouble()
                                : 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= filteredData.length ||
                              value.toInt() < 0) {
                            return const SizedBox();
                          }
                          final DateTime date = DateTime.parse(
                            filteredData[value.toInt()]['data_hora'],
                          );
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('HH:mm').format(date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: spots.length - 1.toDouble(),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.blue,
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String title, String message) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(child: Text(message, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
