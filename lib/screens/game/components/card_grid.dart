import 'package:cards_against_agility/screens/game/components/card_widget.dart';
import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({Key key, this.cards, this.selectedCard, this.onTap}) : super(key: key);

  final List<GameCard> cards;
  final GameCard selectedCard;
  final void Function(GameCard) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {_selectCard(index, onTap);},
            child: CardWidget(card: cards[index])
        );
      },
    );
  }

  void _selectCard(int index, void Function(GameCard) onTap) {
    GameCard newSelected;
    if (selectedCard != cards[index]) {
      if (selectedCard != null) {
        selectedCard.selected = false;
      }
      newSelected = cards[index];
    } else {
      newSelected = null;
    }

    cards[index].selected = !cards[index].selected;
    onTap(newSelected);
  }
}
