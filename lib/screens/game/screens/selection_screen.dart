import 'dart:async';

import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/screens/game/components/card_grid.dart';
import 'package:cards_against_agility/screens/game/components/card_widget.dart';
import 'package:cards_against_agility/bloc/game_repository.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen(this._gameTable);

  final GameTable _gameTable;

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  StreamSubscription<Map<String, dynamic>> listener;
  GameTable _gameTable;
  GameCard _selectedCard;
  final List<GameCard> _cards = <GameCard>[];

  void _gameListener(Map<String, dynamic> map) {
    setState(() {
      _gameTable = GameTable.fromMap(map);
      if(_gameTable.lastVoted.isNotEmpty && !_gameTable.finished()) {
        Navigator.of(context).pushReplacementNamed('/winner', arguments: _gameTable);
      }
    });
  }

  @override
  void initState() {
    _gameTable = widget._gameTable;
    listener = GameRepository().newListener(_gameTable, _gameListener);
    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateCards();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: CardWidget(card: GameCard(text: _gameTable.blackCardText(), type: CardType.BLACK)),
                ),
                CardGrid(cards: _cards, selectedCard: _selectedCard, onTap: updateSelected),
                _voteButton(),
              ]
            ),
          constraints: const BoxConstraints(maxWidth: maxWidth),
          )
        )
      )
    );
  }

  Widget _voteButton() {
    if (Player().isPlayer(_gameTable.host)) {
      return ElevatedButton(
        onPressed: _voteOnCard(),
        child: const Text('Select the funniest one'),
      );
    } else {
      return const OutlineButton(
        onPressed: null,
        child: Text('Waiting for host selection'),
      );
    }
  }

  void _updateCards() {
    _cards.clear();
    for (final MapEntry<String, String> card in _gameTable.playedCards.entries) {
      final GameCard gameCard = GameCard(text: card.value, owner: card.key);
      _selectedCard != null ?
      gameCard.selected = gameCard.text == _selectedCard.text
          : gameCard.selected = false;
      _cards.add(gameCard);
    }
  }

  void updateSelected(GameCard s) {
    setState(() {
      _selectedCard = s;
    });
  }

  Null Function() _voteOnCard() {
    if(_selectedCard == null) {
      return null;
    }

    return () {
      _gameTable.newRound(_selectedCard.owner, _selectedCard.text);
      _selectedCard = null;

      GameRepository().updateDocument(_gameTable);
    };
  }
}
