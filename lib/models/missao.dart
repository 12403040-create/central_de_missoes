class Missao {
  String? id;
  String titulo;
  String dificuldade;
  int pontos;
  bool concluida;
  String data;

  Missao({
    this.id,
    required this.titulo,
    required this.dificuldade,
    required this.pontos,
    this.concluida = false,
    this.data = '',
  });

  // Objeto Dart -> Firebase
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'dificuldade': dificuldade,
      'pontos': pontos,
      'concluida': concluida,
      'data': data,
    };
  }

  // Firebase -> Objeto Dart
  factory Missao.fromMap(Map<String, dynamic> map, String id) {
    return Missao(
      id: id,
      titulo: map['titulo'] ?? '',
      dificuldade: map['dificuldade'] ?? 'Fácil',
      pontos: (map['pontos'] ?? 0) as int,
      concluida: map['concluida'] ?? false,
      data: map['data'] ?? '',
    );
  }

  String get estrelas {
    switch (dificuldade) {
      case 'Difícil':
        return '⭐⭐⭐';
      case 'Médio':
        return '⭐⭐';
      default:
        return '⭐';
    }
  }
}
