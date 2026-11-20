abstract class Formatadores {
  static String _doisDigitos(int numero) {
    return numero.toString().padLeft(2, '0');
  }

  static String hora(DateTime data) {
    return '${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';
  }

  static String duracao(Duration tempo) {
    final horas = tempo.inHours;
    final minutos = tempo.inMinutes.remainder(60);

    if (horas == 0) {
      return '${minutos}min';
    }
    return '${horas}h${_doisDigitos(minutos)}min';
  }

  static String moeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
