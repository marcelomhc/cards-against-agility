import 'package:cards_against_agility/components/game_repository.dart';
import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';

class PlayedCards extends StatefulWidget {
  const PlayedCards(this._gameTable);

  final GameTable _gameTable;

  @override
  _PlayedCardsState createState() => _PlayedCardsState();
}

class _PlayedCardsState extends State<PlayedCards> {
  bool _isHost = false;
  GameTable _gameTable;

  GameCard _selectedCard;
  final List<GameCard> _cards = <GameCard>[];

  @override
  Widget build(BuildContext context) {
    _gameTable = widget._gameTable;

    _updateCards();

    return Column(
      children: <Widget>[
        const Text('Played cards'),
        Container(
          child: GridView.builder(
            padding: const EdgeInsets.all(5),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 7,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () { _selectCard(index); },
                child: _cards[index].widget()
              );
            },
          )
        ),
        _selectWinnerWidget()
      ],
    );
  }

  void _updateCards() {
    _cards.clear();
    for (final MapEntry<String, String> card in _gameTable.playedCards.entries) {
      final GameCard gameCard = GameCard(text: card.value, owner: card.key, type: CardType.HIDEABLE);
      _selectedCard != null ?
        gameCard.selected = gameCard.text == _selectedCard.text
        : gameCard.selected = false;
      _cards.add(gameCard);
    }
    _isHost = Player().isPlayer(_gameTable.host);
    if (_gameTable.voting) {
      GameCard.revealed = true;
    } else {
      GameCard.revealed = false;
    }
  }

  Widget _selectWinnerWidget() {
    if (_isHost && _gameTable.voting) {
      return ElevatedButton(
        onPressed: _voteOnCard(),
        child: const Text('Select Round Winner'),
      );
    } else if (
        _isHost
        && _cards.length == _gameTable.players.length - 1
        && _cards.isNotEmpty
      ) {
      return ElevatedButton(
        onPressed: _startVoting(),
        child: const Text('Reveal Cards'),
      );
    } else {
      return const Text('');
    }
  }

  Null Function() _startVoting() {
    return () {
      _gameTable.startVoting();
      GameRepository().updateDocument(_gameTable);
    };
  }

  void _selectCard(int index) {
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

  Null Function() _voteOnCard() {
    if(_selectedCard == null) {
      return null;
    }

    return () {
      _gameTable.newRound(_selectedCard.owner);
      GameRepository().updateDocument(_gameTable);

      _selectedCard = null;
    };
  }
}
