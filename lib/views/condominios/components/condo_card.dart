import 'package:flutter/material.dart';
import '../../../models/condominio_model.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:google_fonts/google_fonts.dart';

class CondoCard extends StatelessWidget {
  final CondominioModel condominio;
  final VoidCallback onTap;

  const CondoCard({
    Key? key,
    required this.condominio,
    required this.onTap,
    required String reservatorioText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      tz_data.initializeTimeZones();
    } catch (e) {
      print('Erro ao inicializar timezone: $e');
    }

    final brasilTimeZone = tz.getLocation('America/Sao_Paulo');
    final brasilTime = tz.TZDateTime.now(brasilTimeZone);

    final dateFormat = DateFormat('dd/MM/yy HH:mm:ss');
    final formattedDate = dateFormat.format(brasilTime);

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
              Image(
                image: AssetImage(
                  condominio.imageCondo ?? 'assets/default_condo.png',
                ),
                height: 180,
              ),
              const SizedBox(height: 8),
              Text(
                condominio.nome,
                style: GoogleFonts.quicksand(
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
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMetricsRow(condominio),
              const SizedBox(height: 8),
               Text(
                'Toque para ver detalhes',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsRow(CondominioModel condominio) {
    final hasReservatorio = condominio.nivelReservatorioPercentual != null;
    final hasCisterna =
        condominio.hasCisterna == true &&
        condominio.nivelCisternaPercentual != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (hasReservatorio)
          _buildMetricItem(
            'Reservatório',
            '${(condominio.nivelReservatorioPercentual! * 100).toStringAsFixed(2)}%',
            _getColorByLevel(condominio.nivelReservatorioPercentual!),
            Icons.water_drop,
          ),
        if (hasCisterna)
          _buildMetricItem(
            'Cisterna',
            '${(condominio.nivelCisternaPercentual! * 100).toStringAsFixed(2)}%',
            _getColorByLevel(condominio.nivelCisternaPercentual!),
            Icons.water,
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
    if (level < 0.2) {
      // Corrigido para usar valores decimais (0.0 a 1.0)
      return Colors.red;
    } else if (level < 0.3) {
      // 20% a 30%
      return Colors.orange;
    } else {
      return const Color.fromARGB(255, 22, 152, 22); // Verde para nível bom
    }
  }
}
