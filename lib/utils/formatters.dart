class DateFormatter {
  // Formata a data
  static String formatarData(DateTime data) {
    String dia = data.day.toString().padLeft(2, '0');
    String mes = data.month.toString().padLeft(2, '0');
    String ano = data.year.toString();
    String hora = data.hour.toString().padLeft(2, '0');
    String minuto = data.minute.toString().padLeft(2, '0');
    String segundo = data.second.toString().padLeft(2, '0');

    return "$dia/$mes/$ano $hora:$minuto:$segundo";
  }
}
