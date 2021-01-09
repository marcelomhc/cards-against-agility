import 'package:cards_against_agility/models/constants.dart';
import 'package:flutter/material.dart';

enum CardType { BLACK, WHITE, HIDEABLE }

class GameCard {
  GameCard({this.text, this.selected = false, this.owner = '', this.type = CardType.WHITE});

  String text;
  String owner;
  bool selected;
  CardType type;

  static bool revealed = false;

  Color backgroundColor() {
    if(type == CardType.BLACK) {
      return Colors.black87;
    }

    if(type == CardType.HIDEABLE && !revealed) {
      return Colors.white70;
    }

    if(selected) {
      return primaryColor;
    }

    return Colors.white;
  }

  Color textColor() {
    if(type == CardType.BLACK) {
      return Colors.white70;
    }

    if(type == CardType.HIDEABLE && !revealed) {
      return Colors.white70;
    }

    if(selected) {
      return Colors.black87;
    }

    return Colors.black87;
  }

  String cardText() {
    if(type == CardType.HIDEABLE && !revealed) {
      return '';
    }

    return text;
  }

  Widget widget() {
    return Card(
      color: backgroundColor(),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Text(
          cardText(),
          style: TextStyle(
            color: textColor(),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
