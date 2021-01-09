import 'dart:math';

import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/screens/game/model/game_card.dart';


List<GameCard> drawInitialHand() {
  final List<GameCard> cards = <GameCard>[];

  final Set<int> randomCardIdx = <int>{};
  while (randomCardIdx.length < NUMBER_OF_ROUNDS) {
    randomCardIdx.add(Random().nextInt(whiteCards.length));
  }

  for(final int number in randomCardIdx) {
    cards.add(GameCard(text: whiteCards[number]));
  }

  return cards;
}
