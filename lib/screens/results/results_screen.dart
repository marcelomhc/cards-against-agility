import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/bloc/game_repository.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/screens/home/components/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(this.game);

  final GameTable game;
  
  @override
  Widget build(BuildContext context) {
    Map<String, int> score = game.score;

    score = score.map((String key, int value) => MapEntry<String, int>(game.players[key], value));

    final List<String> sortedPlayers = score.keys.toList(growable:false)
      ..sort((String k1, String k2) => score[k2].compareTo(score[k1]));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Game Over',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            const Icon(
              Icons.emoji_events,
              size: 130.0,
              color: Colors.amber,
            ),
            Text(
              '#1 ' + sortedPlayers[0] + ' - ' + score[sortedPlayers[0]].toString(),
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              child: Text(playerList(sortedPlayers, score)),
              padding: const EdgeInsets.all(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {resetGame(context);},
                  child: const Text('Play again'),
                ),
                Padding(
                child: ElevatedButton(
                    onPressed: () { Navigator.of(context).pop(); },
                    child: const Text('Exit'),
                  ),
                padding: const EdgeInsets.only(left: 10.0)
                ),
              ]),
          ],
        ),
      ),
    );
  }

  void resetGame(BuildContext context) {
    GameRepository().getDocument(game.id)
        .then((Map<String, dynamic> map) => doReset(context, GameTable.fromMap(map)));
  }

  void doReset(BuildContext context, GameTable newGame) {
    if(newGame.started()) {
      Navigator.of(context).pushReplacementNamed('/');
      showErrorDialog(context, 'Game is already in progress!');
    } else {
      if (newGame.finished()) {
        newGame.resetGame(Player().id);
      }

      newGame.addPlayer(Player());
      GameRepository().updateDocument(newGame);
      Navigator.of(context).pushReplacementNamed('/lobby', arguments: newGame);
    }
  }

  String playerList(List<String> sortedPlayers, Map<String, int> score) {
    String text = '';
    for(int i = 1; i < sortedPlayers.length; i++) {
      final int points = score[sortedPlayers[i]];
      text += '#${i+1} ${sortedPlayers[i]} - $points\n';
    }
    return text;
  }
}

