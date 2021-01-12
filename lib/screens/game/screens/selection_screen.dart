import 'dart:async';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CardWidget(card: GameCard(text: _gameTable.blackCardText(), type: CardType.BLACK)),
            _cardBuilder(),
            _voteButton(),
          ]
        )
      )
    );
  }

  void _selectCard(int index) {
    if (Player().isPlayer(_gameTable.host)) {
      setState(() {
        if (_selectedCard != _cards[index]) {
          if (_selectedCard != null) {
            _selectedCard.selected = false;
          }
          _selectedCard = _cards[index];
        } else {
          _selectedCard = null;
        }

        _cards[index].selected = !_cards[index].selected;
      });
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

  GridView _cardBuilder() {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      shrinkWrap: true,
      itemCount: _cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () { _selectCard(index); },
            child: CardWidget(card: _cards[index])
        );
      },
    );
  }
}
