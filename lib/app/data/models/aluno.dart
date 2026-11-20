class Aluno {
  final String id;
  final String nome;
  final String telefone;
  final DateTime? entrada;

  const Aluno({
    required this.id,
    required this.nome,
    required this.telefone,
    this.entrada,
  });
  /*bool: a resposta é sim ou não (true / false).
get: avisa que é um getter.
temValidade: o nome da “pergunta”.
=>: “retorna isto aqui”.
validade != null: “a validade é diferente de vazio?”. Se tiver data, dá true. Se estiver vazia, dá false. */
  bool get estaTreinando => entrada != null;

  Aluno copyWith({
    String? nome,
    String? telefone,
    DateTime? entrada,
    bool limparEntrada = false,
  }) {
    return Aluno(
      id: id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      //"quer limpar? Se sim, vazio. Se não, usa o novo, ou senão o atual.”
      entrada: limparEntrada ? null : (entrada ?? this.entrada),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'entrada': entrada?.toIso8601String(),
    };
  }

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      entrada: map['entrada'] != null ? DateTime.parse(map['entrada']) : null,
    );
  }
}
