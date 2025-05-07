import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class VazaoChart extends StatelessWidget {
  final List<Map<String, dynamic>> historicoData;

  const VazaoChart({super.key, required this.historicoData});

  @override
  Widget build(BuildContext context) {
    // Filtrando dados das últimas 24 horas com pressão de saída
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));

    // Filtrando e ordenando dados por data
    final filteredData =
        historicoData.where((data) {
            final dataTime = DateTime.tryParse(data['data_hora'] ?? '');
            return dataTime != null &&
                dataTime.isAfter(last24Hours) &&
                data['vazao'] != null;
          }).toList()
          ..sort((a, b) {
            final dateA =
                DateTime.tryParse(a['data_hora'] ?? '') ?? DateTime(1970);
            final dateB =
                DateTime.tryParse(b['data_hora'] ?? '') ?? DateTime(1970);
            return dateA.compareTo(dateB);
          });

    // Se não houver dados, exibir mensagem
    if (filteredData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Sem dados de vazão nas últimas 24 horas')),
      );
    }

    // Extrair valores e horas para o gráfico
    final spots =
        filteredData.asMap().entries.map((entry) {
          final data = entry.value;
          final pressaoSaida = (data['vazao'] as num).toDouble();
          return FlSpot(entry.key.toDouble(), pressaoSaida);
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
                  return Text(
                    value.toInt().toString(),
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
              color: const Color.fromARGB(255, 216, 82, 49),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color.fromARGB(255, 230, 124, 25).withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
