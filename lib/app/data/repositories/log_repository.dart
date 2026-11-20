import 'dart:convert';
import 'dart:io';

import '../../core/utils/pasta_dados.dart';
import '../models/log_acao.dart';

/// Grava os logs em D:\muscle_mania\logs\, um arquivo por dia,
/// agrupados por aluno (cada aluno tem a sua lista de ações).
class LogRepository {
  Future<File> _arquivoDoDia(DateTime dia) {
    return PastaDados.arquivo(
      subpasta: 'logs',
      nome: '${_nomeDoDia(dia)}.json',
    );
  }

  /// 2026-11-16 (ano-mês-dia, para os arquivos ficarem em ordem)
  String _nomeDoDia(DateTime dia) {
    final mes = dia.month.toString().padLeft(2, '0');
    final diaDoMes = dia.day.toString().padLeft(2, '0');
    return '${dia.year}-$mes-$diaDoMes';
  }

  /// Lê os logs de um dia (um LogAluno para cada aluno).
  Future<List<LogAluno>> buscarDoDia(DateTime dia) async {
    final arquivo = await _arquivoDoDia(dia);

    if (!await arquivo.exists()) {
      return [];
    }

    final conteudo = await arquivo.readAsString();

    if (conteudo.trim().isEmpty) {
      return [];
    }

    final lista = jsonDecode(conteudo) as List;
    return lista
        .map((item) => LogAluno.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  /// Registra uma ação. Se o aluno já tem log no dia, a ação entra
  /// na lista dele. Se não tem, cria o log do aluno com essa ação.
  Future<void> registrar({
    required String alunoId,
    required String alunoNome,
    required Acao acao,
  }) async {
    final arquivo = await _arquivoDoDia(acao.dataHora);
    final logs = await buscarDoDia(acao.dataHora);

    final posicao = logs.indexWhere((log) => log.alunoId == alunoId);

    if (posicao == -1) {
      logs.add(
        LogAluno(alunoId: alunoId, alunoNome: alunoNome, acoes: [acao]),
      );
    } else {
      logs[posicao] = logs[posicao].comNovaAcao(acao, nomeAtual: alunoNome);
    }

    final listaDeMaps = logs.map((log) => log.toMap()).toList();
    final texto = const JsonEncoder.withIndent('  ').convert(listaDeMaps);
    await arquivo.writeAsString(texto);
  }
}
