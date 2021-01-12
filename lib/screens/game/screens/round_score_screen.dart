import 'package:cards_against_agility/screens/game/components/card_widget.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/screens/game/components/score_dialog.dart';
import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';

class RoundScoreScreen extends StatelessWidget {
  const RoundScoreScreen({Key key, this.child}) : super(key: key);

  final GameTable child;

  @override
  Widget build(BuildContext context) {
    final String winner = child.players[child.lastVoted.keys.single];
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CardWidget(card: GameCard(text: child.blackCardText(), type: CardType.BLACK)),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                    child: Text(winner + ' is the winner of this round! +1 point!'),
                  ),
                  CardWidget(card: GameCard(text: child.lastVoted.values.single)),
                  ScoreWidget(child: child)
                ]
            )
        )
    );
  }
}
