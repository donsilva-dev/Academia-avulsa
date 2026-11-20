import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'logo_academia.dart';

class AppBarAcademia extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAcademia({super.key, required this.titulo, this.actions});

  final String titulo;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.barra,
      foregroundColor: Colors.white,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 100,
      shape: const Border(bottom: BorderSide(color: AppColors.borda)),
      actions: actions,
      title: Row(
        children: [
          const LogoAcademia(tamanho: 100),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACADEMIA MUSCLE MANIA',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textoSecundario,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
