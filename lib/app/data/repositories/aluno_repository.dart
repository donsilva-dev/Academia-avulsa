import 'dart:convert';
import 'dart:io';

import 'package:cademia_avulsa/app/core/utils/pasta_dados.dart';
import 'package:cademia_avulsa/app/data/models/aluno.dart';


class AlunoRepository {
   Future<File> _arquivo() =>
      PastaDados.arquivo(subpasta: 'config', nome: 'alunos.json');



  //BUSCAR TODOS
  Future<List<Aluno>> buscarTodos() async {
    final arquivo = await _arquivo();

    if (!await arquivo.exists()) {
      return [];
    }
    final conteudo = await arquivo.readAsString();

    if (conteudo.trim().isEmpty) {
      return [];
    }

    final lista = jsonDecode(conteudo) as List;
    return lista
        .map((item) => Aluno.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // SALVAR TODOS
  Future<void> _salvarTodos(List<Aluno> alunos) async {
    final arquivo = await _arquivo();

    final listaDeMaps = alunos.map((aluno) => aluno.toMap()).toList();

    final texto = const JsonEncoder.withIndent(' ').convert(listaDeMaps);
    await arquivo.writeAsString(texto);
  }

  // ADICIONAR
  Future<void> adicionar(Aluno aluno) async {
    final alunos = await buscarTodos();
    alunos.add(aluno);
    await _salvarTodos(alunos);
  }

  // ATUALIZAR
  /*indexWhere((a) => a.id == aluno.id):
  procura na lista em qual posição está o aluno com o mesmo id.
  Lendo em português:
  “me diz a posição do primeiro aluno a cujo id é igual ao id do aluno que eu recebi”. */
  Future<void> atualizar(Aluno aluno) async {
    final alunos = await buscarTodos();

    final posicao = alunos.indexWhere((a) => a.id == aluno.id);

    if (posicao == -1) {
      return;
    }

    alunos[posicao] = aluno;
    await _salvarTodos(alunos);
  }

  // remover um aluno (remover)

  Future<void> remover(String id) async {
    final alunos = await buscarTodos();
    alunos.removeWhere((a) => a.id == id);
    await _salvarTodos(alunos);
  }

  // descobrir onde o arquivo mora
  Future<String> caminhoDoArquivo() async {
    final arquivo = await _arquivo();
    return arquivo.path;
  }
}
