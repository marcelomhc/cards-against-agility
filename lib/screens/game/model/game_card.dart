import 'package:cards_against_agility/models/constants.dart';
import 'package:flutter/material.dart';

enum CardType { BLACK, WHITE }

class GameCard {
  GameCard({this.text, this.selected = false, this.owner = '', this.type = CardType.WHITE});

  String text;
  String owner;
  bool selected;
  CardType type;

  Color get backgroundColor {
    if(type == CardType.BLACK) {
      return Colors.black87;
    }

    if(selected) {
      return primaryColor;
    }

    return Colors.white;
  }

  Color get textColor {
    if(type == CardType.BLACK) {
      return Colors.white70;
    }

    if(selected) {
      return Colors.black87;
    }

    return Colors.black87;
  }

}
