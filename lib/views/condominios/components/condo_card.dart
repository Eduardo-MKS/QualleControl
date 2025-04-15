import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';
import 'package:intl/intl.dart';

class CondoCard extends StatelessWidget {
  final CondominioModel condominio;
  final VoidCallback onTap;

  // ignore: use_super_parameters
  const CondoCard({Key? key, required this.condominio, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date for display
    final dateFormat = DateFormat('dd/MM/yy HH:mm:ss');
    final formattedDate = dateFormat.format(condominio.ultimaAtualizacao);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(condominio.imageCondo), height: 180),
              const SizedBox(height: 8),
              Text(
                condominio.nome,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.update, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMetricsRow(condominio),
              const SizedBox(height: 8),
              const Text(
                'Toque para ver detalhes',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsRow(CondominioModel condominio) {
    // First, let's determine what metrics this property has
    final hasReservatorio = condominio.nivelReservatorioPercentual > 0;
    final hasCisterna = condominio.hasCisterna == true;
    final hasPressao = condominio.hasPressao == true;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (hasReservatorio)
          _buildMetricItem(
            'Reservatório',
            '${condominio.nivelReservatorioPercentual.toStringAsFixed(2)}%',
            _getColorByLevel(condominio.nivelReservatorioPercentual),
            Icons.water_drop,
          ),
        if (hasCisterna)
          _buildMetricItem(
            'Cisterna',
            '${condominio.nivelCisternaPercentual?.toStringAsFixed(2)}%',
            _getColorByLevel(condominio.nivelCisternaPercentual ?? 0),
            Icons.water,
          ),
        if (hasPressao)
          _buildMetricItem(
            'Pressão Saída',
            '${condominio.pressaoSaida?.toStringAsFixed(1)}mca',
            _getColorByPressure(condominio.pressaoSaida ?? 0),
            Icons.speed,
          ),
      ],
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorByLevel(double level) {
    if (level < 30) {
      return Colors.red;
    } else if (level < 60) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Color _getColorByPressure(double pressure) {
    if (pressure < 80) {
      return Colors.red;
    } else if (pressure > 140) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
