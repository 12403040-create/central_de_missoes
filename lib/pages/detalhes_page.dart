import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/missao_provider.dart';

class DetalhesPage extends StatelessWidget {
  final String missaoId;
  const DetalhesPage({super.key, required this.missaoId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissaoProvider>();
    final lista = provider.missoes.where((m) => m.id == missaoId).toList();

    if (lista.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('DETALHES DA MISSÃO')),
        body: const Center(child: Text('Missão não encontrada')),
      );
    }
    final m = lista.first;

    return Scaffold(
      appBar: AppBar(title: const Text('DETALHES DA MISSÃO')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Título:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(m.titulo, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Dificuldade:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${m.estrelas} ${m.dificuldade}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Pontos:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${m.pontos}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Data:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(m.data, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(m.concluida ? 'Concluída' : 'Pendente',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            if (!m.concluida)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await provider.concluir(m);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Missão concluída! Você conquistou ${m.pontos} pontos.'),
                      ),
                    );
                  },
                  child: const Text('CONCLUIR MISSÃO'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
