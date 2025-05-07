import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReservatorioChart extends StatelessWidget {
  final List<Map<String, dynamic>> historicoData;

  const ReservatorioChart({super.key, required this.historicoData});

  @override
  Widget build(BuildContext context) {
    // Filtrando dados das últimas 24 horas com nível da cisterna
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));

    // Filtrando e ordenando dados por data
    final filteredData =
        historicoData.where((data) {
            final dataTime = DateTime.tryParse(data['data_hora'] ?? '');
            return dataTime != null &&
                dataTime.isAfter(last24Hours) &&
                data['reservatorio_nivel'] != null;
          }).toList()
          ..sort((a, b) {
            final dateA =
                DateTime.tryParse(a['data_hora'] ?? '') ?? DateTime(1970);
            final dateB =
                DateTime.tryParse(b['data_hora'] ?? '') ?? DateTime(1970);
            return dateA.compareTo(dateB);
          });
    if (filteredData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Sem dados de nível do reservatório nas últimas 24 horas',
          ),
        ),
      );
    }

    final spots =
        filteredData.asMap().entries.map((entry) {
          final data = entry.value;
          // Converter o valor decimal para percentual (multiplicar por 100)
          final nivelCisterna =
              (data['reservatorio_nivel'] as num).toDouble() * 100;
          return FlSpot(entry.key.toDouble(), nivelCisterna);
        }).toList();

    // Encontrar valor mínimo e máximo para dimensionar o gráfico
    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Adicionar margem de 10%
    final range = maxY - minY;
    minY = minY - (range * 0.1);
    maxY = maxY + (range * 0.1);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            horizontalInterval: range / 5,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval:
                    filteredData.length > 6
                        ? (filteredData.length / 6).ceil().toDouble()
                        : 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < filteredData.length) {
                    final data = filteredData[value.toInt()];
                    final date = DateTime.tryParse(data['data_hora'] ?? '');
                    if (date != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('HH:mm').format(date),
                          style: const TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: range / 5,
                getTitlesWidget: (value, meta) {
                  // Arredondar para inteiros e adicionar símbolo de percentual
                  return Text(
                    '${value.round()}%',
                    style: const TextStyle(
                      color: Color(0xff67727d),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 0,
          maxX: (filteredData.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.2,
              color: const Color.fromARGB(163, 130, 49, 216),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color.fromARGB(255, 169, 25, 230).withOpacity(0.2),
              ),
            ),
          ],
          // Adicionar ferramenta de tooltip para mostrar o valor exato ao tocar no gráfico
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: const Color.fromARGB(
                255,
                96,
                33,
                130,
              ).withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final index = barSpot.x.toInt();
                  if (index >= 0 && index < filteredData.length) {
                    final data = filteredData[index];
                    final date = DateTime.tryParse(data['data_hora'] ?? '');
                    final formattedDate =
                        date != null
                            ? DateFormat('dd/MM HH:mm').format(date)
                            : '';
                    return LineTooltipItem(
                      '$formattedDate\n${barSpot.y.toStringAsFixed(1)}%',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return null;
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
