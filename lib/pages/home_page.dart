import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/missao.dart';
import '../providers/missao_provider.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tituloController = TextEditingController();
  String _dificuldade = 'Fácil';

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o título da missão')),
      );
      return;
    }
    await context.read<MissaoProvider>().adicionar(titulo, _dificuldade);
    _tituloController.clear();
  }

  Future<void> _concluir(Missao missao) async {
    await context.read<MissaoProvider>().concluir(missao);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Missão concluída!'),
        content: Text('Você conquistou ${missao.pontos} pontos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissaoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('CENTRAL DE MISSÕES')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título da missão',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _dificuldade,
                  decoration: const InputDecoration(
                    labelText: 'Dificuldade',
                    border: OutlineInputBorder(),
                  ),
                  items: const ['Fácil', 'Médio', 'Difícil']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setState(() => _dificuldade = v!),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cadastrar,
                    child: const Text('CADASTRAR MISSÃO'),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'PONTOS CONQUISTADOS: ${provider.pontuacaoTotal}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: provider.missoes.isEmpty
                ? const Center(child: Text('Nenhuma missão cadastrada'))
                : ListView.builder(
                    itemCount: provider.missoes.length,
                    itemBuilder: (context, index) {
                      final m = provider.missoes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalhesPage(missaoId: m.id!),
                            ),
                          ),
                          title: Text(m.titulo,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Dificuldade: ${m.estrelas}\n'
                            'Pontos: ${m.pontos}\n'
                            'Data: ${m.data}\n'
                            'Status: ${m.concluida ? "Concluída" : "Pendente"}',
                          ),
                          isThreeLine: true,
                          trailing: Wrap(
                            children: [
                              if (!m.concluida)
                                IconButton(
                                  tooltip: 'CONCLUIR',
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  onPressed: () => _concluir(m),
                                ),
                              IconButton(
                                tooltip: 'EXCLUIR',
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => context
                                    .read<MissaoProvider>()
                                    .excluir(m),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
