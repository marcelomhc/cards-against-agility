import 'package:cards_against_agility/models/game.dart';
import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({Key key, this.child}) : super(key: key);

  final GameTable child;

  @override
  Widget build(BuildContext context) {
    Map<String, int> score = child.score;

    score = score.map((String key, int value) => MapEntry<String, int>(child.players[key], value));

    final List<String> sortedPlayers = score.keys.toList(growable:false)
      ..sort((String k1, String k2) => score[k2].compareTo(score[k1]));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Score', style: TextStyle(fontSize: 20.0),),
        Text(playerList(sortedPlayers, score)),
        ElevatedButton(
          onPressed: () { Navigator.of(context).pop(); },
          child: const Text('Close'),
        )
      ]
    );
  }

  String playerList(List<String> sortedPlayers, Map<String, int> score) {
    String text = '\n';
    for(int i = 0; i < sortedPlayers.length; i++) {
      final int points = score[sortedPlayers[i]];
      text += '#${i+1} ${sortedPlayers[i]} - $points\n';
    }
    return text;
  }
}
