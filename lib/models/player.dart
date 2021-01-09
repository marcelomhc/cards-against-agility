import 'dart:math';

import 'package:cards_against_agility/models/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Player {
  factory Player() => _instance;

  Player._() {
    FirebaseAuth.instance.signInAnonymously()
      .then((_) {
        _player = FirebaseAuth.instance.currentUser;
      });
  }

  static final Player _instance = Player._();
  User _player;
  String _username =
      colors.elementAt(Random().nextInt(colors.length))
      + animals.elementAt(Random().nextInt(animals.length));

  String get id => _player.uid;

  String get username => _username;
  
  void setName(String name) {
    _username = name;
  }

  bool isPlayer(String id) {
    return id == _player.uid;
  }
}
