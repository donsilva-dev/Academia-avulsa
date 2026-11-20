abstract class CalculadoraCobranca {
  static const double valorPorHora = 5.0;

  static int horasCobradas(Duration tempo) {
    final minutos = tempo.inMinutes;

    if (minutos <= 0) {
      return 1;
    }

    return (minutos / 60).ceil();
  }

  static double valor(Duration tempo) {
    return horasCobradas(tempo) * valorPorHora;
  }
}
