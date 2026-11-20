import 'package:flutter/material.dart';

import '../utils/logo_helper.dart';

class LogoAcademia extends StatelessWidget {
  const LogoAcademia({super.key, this.tamanho = 130});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    final logo = LogoHelper.buscarLogo();

    if (logo == null) {
      return Icon(Icons.fitness_center, size: tamanho);
    }

    return Image.file(
      logo,
      width: tamanho,
      height: tamanho,
      fit: BoxFit.contain,
      errorBuilder: (context, erro, stack) =>
          Icon(Icons.fitness_center, size: tamanho),
    );
  }
}
