import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key key, this.card}) : super(key: key);

  final GameCard card;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width / 3,
        child: AspectRatio(
          aspectRatio: 0.9,
          child: Card(
            color: card.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10.0),
              child: Text(
                card.text,
                style: TextStyle(
                  color: card.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
