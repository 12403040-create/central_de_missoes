import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/missao.dart';

class MissaoService {
  final CollectionReference _colecao =
      FirebaseFirestore.instance.collection('missoes');

  Future<void> adicionar(Missao missao) async {
    await _colecao.add(missao.toMap());
  }

  Future<List<Missao>> buscarTodas() async {
    final snapshot = await _colecao.get();
    return snapshot.docs
        .map((doc) => Missao.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> atualizar(Missao missao) async {
    await _colecao.doc(missao.id).update(missao.toMap());
  }

  Future<void> excluir(String id) async {
    await _colecao.doc(id).delete();
  }
}
