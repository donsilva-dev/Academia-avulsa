import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.label,
    required this.controller,
    required this.icone,
    this.dica,
    this.ajuda,
    this.validator,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final IconData icone;
  final String? dica;
  final String? ajuda;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textoCampo, fontSize: 16),
          decoration: InputDecoration(
            hintText: dica,
            hintStyle: const TextStyle(color: AppColors.dicaCampo),
            helperText: ajuda,
            helperStyle: const TextStyle(color: AppColors.textoSecundario),
            errorStyle: const TextStyle(color: AppColors.erro),
            prefixIcon: Icon(icone, color: AppColors.iconeCampo),
            filled: true,
            fillColor: AppColors.campo,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            enabledBorder: _borda(Colors.transparent),
            focusedBorder: _borda(AppColors.destaque),
            errorBorder: _borda(AppColors.erro),
            focusedErrorBorder: _borda(AppColors.erro),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _borda(Color cor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cor, width: 2),
    );
  }
}
