import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatadores.dart';
import '../../../../data/models/aluno.dart';

/// Card de um aluno na lista.
///
/// Ele só DESENHA: não conhece o controller. As ações dos botões chegam
/// de fora pelos VoidCallback (quem usa o card decide o que cada botão faz).
class AlunoCard extends StatelessWidget {
  const AlunoCard({
    super.key,
    required this.aluno,
    required this.onEntrada,
    required this.onSaida,
    required this.onEditar,
    required this.onExcluir,
  });

  final Aluno aluno;
  final VoidCallback onEntrada;
  final VoidCallback onSaida;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    final treinando = aluno.estaTreinando;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.barra,
        borderRadius: BorderRadius.circular(12),
        // Borda verde quando o aluno está na academia
        border: Border.all(
          color: treinando ? AppColors.sucesso : AppColors.borda,
        ),
      ),
      child: Row(
        children: [
          // Ícone redondo: halter verde (treinando) ou pessoa (fora)
          CircleAvatar(
            radius: 24,
            backgroundColor: treinando
                ? AppColors.sucessoFundo
                : AppColors.borda,
            child: Icon(
              treinando ? Icons.fitness_center : Icons.person,
              color: treinando ? AppColors.sucesso : AppColors.label,
            ),
          ),
          const SizedBox(width: 16),

          // Nome e telefone (ou horário de entrada), ocupando o meio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aluno.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  treinando
                      ? 'Treinando desde ${Formatadores.hora(aluno.entrada!)}'
                      : aluno.telefone,
                  style: TextStyle(
                    color: treinando
                        ? AppColors.sucesso
                        : AppColors.textoSecundario,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Um botão só, que vira Entrada ou Saída conforme o estado
          FilledButton.icon(
            onPressed: treinando ? onSaida : onEntrada,
            icon: Icon(treinando ? Icons.logout : Icons.login),
            label: Text(treinando ? 'Saída' : 'Entrada'),
            style: FilledButton.styleFrom(
              backgroundColor: treinando ? AppColors.saida : AppColors.destaque,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 8),

          IconButton(
            tooltip: 'Editar',
            onPressed: onEditar,
            icon: const Icon(Icons.edit_outlined, color: AppColors.label),
          ),
          IconButton(
            tooltip: 'Excluir',
            onPressed: onExcluir,
            icon: const Icon(Icons.delete_outline, color: AppColors.erro),
          ),
        ],
      ),
    );
  }
}
