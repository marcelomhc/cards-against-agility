import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key key, this.text, this.type = CardType.BLACK}) : super(key: key);

  final String text;
  final CardType type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width / 3,
        child: AspectRatio(
          aspectRatio: 0.9,
          child: GameCard(text: text, type: type).widget(),
        ),
      ),
    );
  }
}
