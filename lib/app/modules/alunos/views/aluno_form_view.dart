import 'package:cademia_avulsa/app/core/theme/app_colors.dart';
import 'package:cademia_avulsa/app/core/widgets/app_bar_academia.dart';
import 'package:cademia_avulsa/app/core/widgets/campo_texto.dart';
import 'package:cademia_avulsa/app/data/models/aluno.dart';
import 'package:cademia_avulsa/app/modules/alunos/controllers/alunos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlunoFormView extends StatefulWidget {
  const AlunoFormView({super.key});

  @override
  State<AlunoFormView> createState() => _AlunoFormViewState();
}

class _AlunoFormViewState extends State<AlunoFormView> {
  final controller = Get.find<AlunosController>();

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();

  Aluno? alunoEmEdicao;

  @override
  void initState() {
    super.initState();
    alunoEmEdicao = Get.arguments as Aluno?;

    if (alunoEmEdicao != null) {
      nomeController.text = alunoEmEdicao!.nome;
      telefoneController.text = alunoEmEdicao!.telefone;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    if (!formKey.currentState!.validate()) return;

    final nome = nomeController.text.trim();
    final telefone = telefoneController.text.trim();

    if (alunoEmEdicao == null) {
      await controller.adicionar(nome, telefone);
    } else {
      await controller.atualizar(alunoEmEdicao!, nome, telefone);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final editando = alunoEmEdicao != null;

    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBarAcademia(titulo: editando ? 'Editar aluno' : 'Novo aluno'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    editando ? 'Editar dados' : 'Cadastrar aluno',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Preencha os dados do aluno para registrar a entrada dele na academia.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CampoTexto(
                    label: 'Nome completo',
                    controller: nomeController,
                    icone: Icons.person_outline,
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe o nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CampoTexto(
                    label: 'Telefone',
                    controller: telefoneController,
                    icone: Icons.smartphone,
                    dica: '(11) 99999-0000',
                    ajuda: 'Com DDD, só números ou no formato (11) 99999-0000',
                    keyboardType: TextInputType.phone,
                    validator: (valor) {
                      if (valor == null || valor.trim().length < 10) {
                        return 'Informe o telefone com DDD';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.barra,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borda),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.schedule, color: Color(0xFFB9A6FF)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cobrança de R\$ 5,00 por hora. Hora iniciada conta como hora cheia.',
                            style: TextStyle(color: AppColors.label),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF4A4560)),
                          minimumSize: const Size(0, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: salvar,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.destaque,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Salvar aluno'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
