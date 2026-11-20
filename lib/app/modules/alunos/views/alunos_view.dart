import 'package:cademia_avulsa/app/core/theme/app_colors.dart';
import 'package:cademia_avulsa/app/core/utils/formatadores.dart';
import 'package:cademia_avulsa/app/core/widgets/app_bar_academia.dart';
import 'package:cademia_avulsa/app/data/models/aluno.dart';
import 'package:cademia_avulsa/app/modules/alunos/controllers/alunos_controller.dart';
import 'package:cademia_avulsa/app/modules/alunos/views/widgets/aluno_card.dart';
import 'package:cademia_avulsa/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlunosView extends GetView<AlunosController> {
  const AlunosView({super.key});

  // ---------------------------------------------------------------------------
  // BUILD: só monta as "peças" da tela, de cima para baixo
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: const AppBarAcademia(titulo: 'Alunos'),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              _barraDeBusca(),
              _resumo(),
              Expanded(child: _lista()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _rodape(),
    );
  } // <- fecha o build

  // ---------------------------------------------------------------------------
  // PEÇAS DA TELA
  // ---------------------------------------------------------------------------

  /// Campo de busca com lupa + botão "Novo aluno".
  Widget _barraDeBusca() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (texto) => controller.busca.value = texto,
              style: const TextStyle(color: AppColors.textoCampo, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Buscar aluno pelo nome',
                hintStyle: const TextStyle(color: AppColors.dicaCampo),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.iconeCampo,
                ),
                filled: true,
                fillColor: AppColors.campo,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.destaque,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () => Get.toNamed(AppRoutes.alunoForm),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.destaque,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 52),
              padding: const EdgeInsets.fromLTRB(14, 0, 20, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 18,
                    color: AppColors.destaque,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Novo aluno',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Etiquetas: "4 alunos" e "1 treinando agora".
  Widget _resumo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Obx(() {
        final total = controller.alunos.length;
        final treinando = controller.totalTreinando;

        return Row(
          children: [
            _etiqueta(
              total == 1 ? '1 aluno' : '$total alunos',
              cor: AppColors.label,
              fundo: AppColors.barra,
            ),
            const SizedBox(width: 8),
            _etiqueta(
              '$treinando treinando agora',
              cor: AppColors.sucesso,
              fundo: AppColors.sucessoFundo,
            ),
          ],
        );
      }),
    );
  }

  /// Uma etiqueta arredondada (formato de "pílula").
  Widget _etiqueta(String texto, {required Color cor, required Color fundo}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borda),
      ),
      child: Text(texto, style: TextStyle(color: cor, fontSize: 13)),
    );
  }

  /// A lista de cards (já filtrada pela busca).
  Widget _lista() {
    return Obx(() {
      if (controller.carregando.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.destaque),
        );
      }

      if (controller.alunos.isEmpty) {
        return _estadoVazio(
          icone: Icons.group_outlined,
          titulo: 'Nenhum aluno cadastrado',
          dica: 'Clique em "Novo aluno" para cadastrar o primeiro.',
        );
      }

      final lista = controller.alunosFiltrados;

      if (lista.isEmpty) {
        return _estadoVazio(
          icone: Icons.search_off,
          titulo: 'Nenhum aluno encontrado',
          dica: 'Confira se o nome foi digitado certinho.',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        itemCount: lista.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final aluno = lista[index];

          return KeyedSubtree(
            key: ValueKey(aluno.id),
            child: Obx(() {
              final estaSaindo = controller.saindo.contains(aluno.id);
              const duracao = Duration(milliseconds: 350);

              return ClipRect(
                clipBehavior: estaSaindo ? Clip.hardEdge : Clip.none,
                child: AnimatedAlign(
                  alignment: Alignment.topCenter,
                  heightFactor: estaSaindo ? 0 : 1,
                  duration: duracao,
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: estaSaindo ? 0 : 1,
                    duration: duracao,
                    child: AnimatedSlide(
                      offset: estaSaindo ? const Offset(0.25, 0) : Offset.zero,
                      duration: duracao,
                      curve: Curves.easeInCubic,
                      child: AlunoCard(
                        aluno: aluno,
                        onEntrada: () => controller.registrarEntrada(aluno),
                        onSaida: () => _confirmarSaida(aluno),
                        onEditar: () =>
                            Get.toNamed(AppRoutes.alunoForm, arguments: aluno),
                        onExcluir: () => _confirmarExclusao(aluno),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      );
    });
  }

  /// Mensagem amigável quando não há nada para mostrar.
  Widget _estadoVazio({
    required IconData icone,
    required String titulo,
    required String dica,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 64, color: AppColors.textoSecundario),
          const SizedBox(height: 16),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(dica, style: const TextStyle(color: AppColors.textoSecundario)),
        ],
      ),
    );
  }

  /// Rodapé com o crédito do desenvolvedor.
  Widget _rodape() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borda)),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 13, color: AppColors.textoSecundario),
          children: [
            TextSpan(text: 'Desenvolvido por '),
            TextSpan(
              text: 'Douglas Nunes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.label,
              ),
            ),
            TextSpan(text: ' · v1.0'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AÇÕES (janelas de saída e de exclusão)
  // ---------------------------------------------------------------------------

  /// Registra a saída e mostra o resumo com tempo e valor.
  /// Mostra o resumo e só registra a saída se o usuário confirmar.
  Future<void> _confirmarSaida(Aluno aluno) async {
    final entrada = aluno.entrada!;
    final agora = DateTime.now();
    final tempo = agora.difference(entrada);
    final horas = controller.horasCobradas(tempo);
    final valor = controller.valorAPagar(tempo);

    final confirmou = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.barra,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borda),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.borda,
              child: Icon(Icons.logout, color: AppColors.label),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Confirmar saída de',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  Text(
                    aluno.nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _linha('Entrada', Formatadores.hora(entrada)),
              _linha('Saída', Formatadores.hora(agora)),
              _linha('Tempo na academia', Formatadores.duracao(tempo)),
              _linha('Horas cobradas', '${horas}h × ${Formatadores.moeda(5)}'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.fundo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.destaque, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total a pagar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      Formatadores.moeda(valor),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(result: false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF4A4560)),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Get.back(result: true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.saida,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Confirmar saída'),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    await controller.registrarSaida(aluno);

    Get.snackbar(
      'Saída registrada',
      '${aluno.nome} · ${Formatadores.moeda(valor)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.barra,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: AppColors.sucesso),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  /// Uma linha do resumo: título na esquerda, valor na direita.
  Widget _linha(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textoSecundario,
            ),
          ),
          const SizedBox(width: 24),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Pergunta se pode excluir. Só exclui se o usuário confirmar.
  Future<void> _confirmarExclusao(Aluno aluno) async {
    final confirmou = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.barra,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borda),
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.perigoFundo,
                child: Icon(Icons.delete_outline, color: AppColors.erro),
              ),
              const SizedBox(height: 16),
              const Text(
                'Excluir aluno?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.label,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Tem certeza que deseja excluir '),
                    TextSpan(
                      text: aluno.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(text: '? Essa ação não pode ser desfeita.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(result: false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF4A4560)),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Get.back(result: true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.perigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Excluir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmou == true) {
      await controller.remover(aluno);
    }
  }
} // <- fecha a classe
