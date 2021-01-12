import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerRepository {
  factory PlayerRepository() => _instance;

  PlayerRepository._() : _collection = FirebaseFirestore.instance.collection('users');

  static final PlayerRepository _instance = PlayerRepository._();
  CollectionReference _collection;

  Future<String> getUsername(String id) async {
    return _collection
        .doc(id)
        .get()
        .then((DocumentSnapshot value) => value.data()['username'] as String);
  }

  void setUsername(String id, String username) {
    _collection.doc(id).set(<String, String>{'username': username});
  }

}