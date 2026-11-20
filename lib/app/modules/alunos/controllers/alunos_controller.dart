import 'package:cademia_avulsa/app/core/utils/calculadora_cobranca.dart';
import 'package:cademia_avulsa/app/core/utils/formatadores.dart';
import 'package:cademia_avulsa/app/data/models/aluno.dart';
import 'package:cademia_avulsa/app/data/models/log_acao.dart';
import 'package:cademia_avulsa/app/data/repositories/aluno_repository.dart';
import 'package:cademia_avulsa/app/data/repositories/log_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AlunosController extends GetxController {
  AlunosController(this._repository, this._logRepository);

  final AlunoRepository _repository;
  final LogRepository _logRepository;

  // ---------------------------------------------------------------------------
  // ESTADO (variáveis reativas que a tela observa)
  // ---------------------------------------------------------------------------
  final alunos = <Aluno>[].obs;
  final carregando = false.obs;
  final saindo = <String>[].obs; // ids dos cards que estão animando a saída
  final busca = ''.obs;

  // ---------------------------------------------------------------------------
  // CICLO DE VIDA E CARREGAMENTO
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    carregarAlunos(mostrarCarregando: true);
  }

  Future<void> carregarAlunos({bool mostrarCarregando = false}) async {
    if (mostrarCarregando) carregando.value = true;
    try {
      final lista = await _repository.buscarTodos();
      alunos.assignAll(lista);
    } finally {
      carregando.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // INFORMAÇÕES PARA A TELA (getters)
  // ---------------------------------------------------------------------------
  List<Aluno> get alunosFiltrados {
    final termo = busca.value.trim().toLowerCase();
    if (termo.isEmpty) return alunos;

    return alunos
        .where((aluno) => aluno.nome.toLowerCase().contains(termo))
        .toList();
  }

  int get totalTreinando => alunos.where((aluno) => aluno.estaTreinando).length;

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------
  Future<void> adicionar(String nome, String telefone) async {
    final novo = Aluno(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      telefone: telefone,
    );
    await _repository.adicionar(novo);
    await carregarAlunos();
    await _registrarLog(TipoAcao.cadastro, novo);
  }

  Future<void> atualizar(Aluno aluno, String nome, String telefone) async {
    final editado = aluno.copyWith(nome: nome, telefone: telefone);
    await _repository.atualizar(editado);
    await carregarAlunos();
    await _registrarLog(
      TipoAcao.edicao,
      editado,
      detalhe: aluno.nome != nome ? 'Antes: ${aluno.nome}' : null,
    );
  }

  Future<void> remover(Aluno aluno) async {
    await _animarSaida(aluno.id);
    await _repository.remover(aluno.id);
    await carregarAlunos();
    saindo.remove(aluno.id);
    await _registrarLog(TipoAcao.exclusao, aluno);
  }

  // ---------------------------------------------------------------------------
  // ENTRADA E SAÍDA
  // ---------------------------------------------------------------------------
  Future<void> registrarEntrada(Aluno aluno) async {
    final chegou = aluno.copyWith(entrada: DateTime.now());
    await _repository.atualizar(chegou);
    await carregarAlunos();
    await _registrarLog(TipoAcao.entrada, aluno);
  }

  Future<Duration?> registrarSaida(Aluno aluno) async {
    final entrada = aluno.entrada;
    if (entrada == null) return null;

    // Calcula ANTES de remover (depois não teria mais o horário de entrada)
    final tempo = DateTime.now().difference(entrada);
    final valor = valorAPagar(tempo);

    await _animarSaida(aluno.id);
    await _repository.remover(aluno.id);
    await carregarAlunos();
    saindo.remove(aluno.id);

    await _registrarLog(
      TipoAcao.saida,
      aluno,
      detalhe:
          '${Formatadores.duracao(tempo)} · ${horasCobradas(tempo)}h cobradas',
      valor: valor,
    );

    return tempo;
  }

  // ---------------------------------------------------------------------------
  // COBRANÇA (atalhos para a calculadora)
  // ---------------------------------------------------------------------------
  double valorAPagar(Duration tempo) => CalculadoraCobranca.valor(tempo);

  int horasCobradas(Duration tempo) => CalculadoraCobranca.horasCobradas(tempo);

  // ---------------------------------------------------------------------------
  // AUXILIARES PRIVADOS
  // ---------------------------------------------------------------------------

  /// Marca o card como "saindo" e espera a animação terminar.
  Future<void> _animarSaida(String id) async {
    saindo.add(id);
    await Future.delayed(const Duration(milliseconds: 350));
  }

  /// Grava a ação na lista de logs do aluno.
  /// Se falhar, NÃO interrompe a ação principal.
  Future<void> _registrarLog(
    TipoAcao tipo,
    Aluno aluno, {
    String? detalhe,
    double? valor,
  }) async {
    try {
      await _logRepository.registrar(
        alunoId: aluno.id,
        alunoNome: aluno.nome,
        acao: Acao(
          tipo: tipo,
          dataHora: DateTime.now(),
          detalhe: detalhe,
          valor: valor,
        ),
      );
    } catch (erro) {
      debugPrint('Não foi possível registrar o log: $erro');
    }
  }
}
