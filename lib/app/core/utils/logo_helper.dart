import 'dart:io';

abstract class LogoHelper {
  static const _caminhosPossiveis = [
    r'C:\muscle_mania\pictures\logo.png',
    r'D:\muscle_mania\pictures\logo.png',
  ];

  static File? buscarLogo() {
    for (final caminho in _caminhosPossiveis) {
      final arquivo = File(caminho);
      if (arquivo.existsSync()) {
        return arquivo;
      }
    }
    return null;
  }
}
