/// Os tipos de ação que viram log.
enum TipoAcao { cadastro, edicao, entrada, saida, exclusao }

/// UMA ação que aconteceu com um aluno (ex.: a entrada às 15:53).
class Acao {
  final TipoAcao tipo;
  final DateTime dataHora;
  final String? detalhe;
  final double? valor; // só a saída tem valor

  const Acao({
    required this.tipo,
    required this.dataHora,
    this.detalhe,
    this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo.name,
      'dataHora': dataHora.toIso8601String(),
      'detalhe': detalhe,
      'valor': valor,
    };
  }

  factory Acao.fromMap(Map<String, dynamic> map) {
    return Acao(
      tipo: TipoAcao.values.byName(map['tipo']),
      dataHora: DateTime.parse(map['dataHora']),
      detalhe: map['detalhe'],
      valor: (map['valor'] as num?)?.toDouble(),
    );
  }
}

/// O log de UM aluno no dia: quem é ele + a lista de tudo que aconteceu.
class LogAluno {
  final String alunoId;
  final String alunoNome;
  final List<Acao> acoes;

  const LogAluno({
    required this.alunoId,
    required this.alunoNome,
    required this.acoes,
  });

  /// Devolve um LogAluno NOVO com a ação adicionada no final.
  /// Se o nome mudou (edição), já guarda o nome atualizado.
  LogAluno comNovaAcao(Acao acao, {required String nomeAtual}) {
    return LogAluno(
      alunoId: alunoId,
      alunoNome: nomeAtual,
      acoes: [...acoes, acao],
    );
  }

  /// Soma de tudo que esse aluno pagou no dia.
  double get totalPago =>
      acoes.fold(0.0, (soma, acao) => soma + (acao.valor ?? 0));

  Map<String, dynamic> toMap() {
    return {
      'alunoId': alunoId,
      'alunoNome': alunoNome,
      'acoes': acoes.map((acao) => acao.toMap()).toList(),
    };
  }

  factory LogAluno.fromMap(Map<String, dynamic> map) {
    final lista = map['acoes'] as List;
    return LogAluno(
      alunoId: map['alunoId'],
      alunoNome: map['alunoNome'],
      acoes: lista
          .map((item) => Acao.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
