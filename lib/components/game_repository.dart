import 'dart:async';

import 'package:cards_against_agility/models/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameRepository {
  factory GameRepository() => _instance;
  GameRepository._() : _collection = FirebaseFirestore.instance.collection('tables');

  static final GameRepository _instance = GameRepository._();
  CollectionReference _collection;


  Future<Map<String, dynamic>> getDocument(String docId) async {
    return _collection
      .doc(docId)
      .get()
      .then((DocumentSnapshot doc) => doc.data());
  }

  Future<Map<String, dynamic>> setDocument(String docId, Map<String, dynamic> data) async {
    final DocumentReference docRef = _collection.doc(docId);
    docRef.set(data);
    return docRef.get().then((DocumentSnapshot snap) => snap.data());
  }

  void updateDocument(GameTable table) {
    _collection.doc(table.id).update(table.toMap());
  }

  Future<bool> exists(String docId) async {
    return _collection
        .doc(docId)
        .get()
        .then((DocumentSnapshot doc) => doc.exists);
  }

  StreamSubscription<Map<String, dynamic>> newListener(GameTable table, void Function(Map<String, dynamic>) listener) {
    return _collection.doc(table.id).snapshots().map((DocumentSnapshot doc) => doc.data()).listen(listener);
  }
}