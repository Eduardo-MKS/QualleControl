import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CisternaChart extends StatelessWidget {
  final List<Map<String, dynamic>> historicoData;

  const CisternaChart({super.key, required this.historicoData});

  @override
  Widget build(BuildContext context) {
    // Filtrando dados das últimas 24 horas com nível de qualquer cisterna
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));

    // Filtrando e ordenando dados por data
    final filteredData =
        historicoData.where((data) {
            final dataTime = DateTime.tryParse(data['data_hora'] ?? '');
            // Verificar se existe qualquer dado de cisterna (cisterna_nivel OU cisterna1_nivel)
            return dataTime != null &&
                dataTime.isAfter(last24Hours) &&
                (data['cisterna_nivel'] != null ||
                    data['cisterna1_nivel'] != null);
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
          child: Text('Sem dados de nível das cisternas nas últimas 24 horas'),
        ),
      );
    }

    // Criar spots para cisterna_nivel (cisterna principal)
    final spotsCisterna =
        filteredData
            .asMap()
            .entries
            .map((entry) {
              final data = entry.value;
              // Verificar se existe cisterna_nivel e converter para percentual
              if (data['cisterna_nivel'] != null) {
                final nivelCisterna =
                    (data['cisterna_nivel'] as num).toDouble() * 100;
                return FlSpot(entry.key.toDouble(), nivelCisterna);
              }
              return null; // Retorna null para pontos que não têm este dado
            })
            .where((spot) => spot != null)
            .toList()
            .cast<FlSpot>();

    // Criar spots para cisterna1_nivel (cisterna secundária)
    final spotsCisterna1 =
        filteredData
            .asMap()
            .entries
            .map((entry) {
              final data = entry.value;
              // Verificar se existe cisterna1_nivel e converter para percentual
              if (data['cisterna1_nivel'] != null) {
                final nivelCisterna1 =
                    (data['cisterna1_nivel'] as num).toDouble() * 100;
                return FlSpot(entry.key.toDouble(), nivelCisterna1);
              }
              return null; // Retorna null para pontos que não têm este dado
            })
            .where((spot) => spot != null)
            .toList()
            .cast<FlSpot>();

    // Verificar se temos dados para pelo menos uma das cisternas
    if (spotsCisterna.isEmpty && spotsCisterna1.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('Dados de nível das cisternas não disponíveis'),
        ),
      );
    }

    // Encontrar valores mínimos e máximos combinando ambas as cisternas
    final allSpots = [...spotsCisterna, ...spotsCisterna1];
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var spot in allSpots) {
      if (spot.y < minY) minY = spot.y;
      if (spot.y > maxY) maxY = spot.y;
    }

    // Adicionar margem de 10%
    final range =
        maxY - minY > 0 ? maxY - minY : 10.0; // Evitar divisão por zero
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
            // Dados da cisterna principal (se existirem)
            if (spotsCisterna.isNotEmpty)
              LineChartBarData(
                spots: spotsCisterna,
                isCurved: true,
                curveSmoothness: 0.2,
                color: const Color.fromARGB(255, 49, 116, 216),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color.fromARGB(
                    255,
                    25,
                    131,
                    230,
                  ).withOpacity(0.2),
                ),
              ),
            // Dados da cisterna secundária (se existirem)
            if (spotsCisterna1.isNotEmpty)
              LineChartBarData(
                spots: spotsCisterna1,
                isCurved: true,
                curveSmoothness: 0.2,
                color: const Color.fromARGB(
                  255,
                  49,
                  116,
                  216,
                ), // Cor diferente para a segunda cisterna
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color.fromARGB(
                    255,
                    25,
                    97,
                    230,
                  ).withOpacity(0.2),
                ),
              ),
          ],
          // Adicionar ferramenta de tooltip para mostrar o valor exato ao tocar no gráfico
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueAccent.withOpacity(0.8),
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

                    // Identificar qual cisterna foi tocada baseada na cor
                    final bool isPrimaryCisterna =
                        barSpot.barIndex == 0 && spotsCisterna.isNotEmpty ||
                        (spotsCisterna.isEmpty && barSpot.barIndex == 0);

                    final cisternName =
                        isPrimaryCisterna ? 'Cisterna 1' : 'Cisterna 2';

                    return LineTooltipItem(
                      '$formattedDate\n$cisternName: ${barSpot.y.toStringAsFixed(1)}%',
                      TextStyle(
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
