import 'package:flutter/material.dart';
import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService _service = MissaoService();
  List<Missao> missoes = [];

  // Soma apenas as missões concluídas
  int get pontuacaoTotal =>
      missoes.where((m) => m.concluida).fold(0, (soma, m) => soma + m.pontos);

  int _pontosPorDificuldade(String dificuldade) {
    switch (dificuldade) {
      case 'Difícil':
        return 30;
      case 'Médio':
        return 20;
      default:
        return 10;
    }
  }

  String _dataHoje() {
    final h = DateTime.now();
    final d = h.day.toString().padLeft(2, '0');
    final m = h.month.toString().padLeft(2, '0');
    return '$d/$m/${h.year}';
  }

  Future<void> carregar() async {
    missoes = await _service.buscarTodas();
    notifyListeners();
  }

  Future<void> adicionar(String titulo, String dificuldade) async {
    final missao = Missao(
      titulo: titulo,
      dificuldade: dificuldade,
      pontos: _pontosPorDificuldade(dificuldade),
      concluida: false,
      data: _dataHoje(),
    );
    await _service.adicionar(missao);
    await carregar();
  }

  Future<void> concluir(Missao missao) async {
    missao.concluida = true;
    await _service.atualizar(missao);
    await carregar();
  }

  Future<void> excluir(Missao missao) async {
    await _service.excluir(missao.id!);
    await carregar();
  }
}
