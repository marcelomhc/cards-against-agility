import 'dart:math';

import 'package:cards_against_agility/bloc/game_repository.dart';
import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/screens/home/components/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> createGame(BuildContext context) async {
  showLoaderDialog(context);

  String gameCode;
  do {
    gameCode = String.fromCharCodes(
        List<int>.generate(7, (int index) => Random().nextInt(26) + 65)
    );
  } while(await GameRepository().exists(gameCode));

  final GameTable game = GameTable.fromScratch(
    gameCode,
    Player().id,
    <int>[Random().nextInt(blackCards.length)]
  );
  game.addPlayer(Player());

  GameRepository()
    .setDocument(gameCode, game.toMap())
    .then((_) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/lobby', arguments: game);
    });
}

void searchGame(BuildContext context, String gameCode) {
  showLoaderDialog(context);

  GameRepository()
    .getDocument(gameCode)
    .then((Map<String, dynamic> map) => joinGame(context, map));
}

void joinGame(BuildContext context, Map<String, dynamic> map) {
  Navigator.pop(context);

  if(map != null) {
    Navigator.pop(context);
    final GameTable game = GameTable.fromMap(map);
    if (game.waitingPlayers() || game.players.keys.contains(Player().id)) {
      game.addPlayer(Player());
      GameRepository().updateDocument(game);
      Navigator.pushNamed(context, '/lobby', arguments: game);
    } else {
      showErrorDialog(context, 'Game already in progress!');
    }
  } else {
    showErrorDialog(context, 'Game not found!');
  }
}
