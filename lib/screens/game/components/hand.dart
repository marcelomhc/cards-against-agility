import 'package:cards_against_agility/bloc/game_repository.dart';
import 'package:cards_against_agility/screens/game/components/card_widget.dart';
import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/screens/game/bloc/round.dart';
import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';

class Hand extends StatefulWidget {
  const Hand(this._gameTable);

  final GameTable _gameTable;

  @override
  _HandState createState() => _HandState();
}

class _HandState extends State<Hand> {
  GameCard _selectedCard;
  GameTable _gameTable;
  final List<GameCard> _cards = drawInitialHand();

  @override
  Widget build(BuildContext context) {
    _gameTable = widget._gameTable;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: primaryColor.withOpacity(0.5),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          const Padding(
            child: Text('My cards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
            padding: EdgeInsets.only(top: 10.0),
          ),
          GridView.builder(
            padding: const EdgeInsets.all(5),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () { _selectCard(index); },
                child: CardWidget(card: _cards[index])
              );
            },
          ),
          ElevatedButton(
            onPressed: _isAllowedToPlay(),
            child: Text(_getPlayCardText()),
          ),
        ],
      )
    );
  }

  Null Function() _isAllowedToPlay() {
    return _hasPlayed() || Player().isPlayer(_gameTable.host) ? null : _playCard();
  }

  String _getPlayCardText() {
    return Player().isPlayer(_gameTable.host) ?
        'You are the host'
        : _hasPlayed() ?
          'Waiting for other players'
          : 'Play selected card';
  }

  bool _hasPlayed() {
    return _gameTable.playedCards.keys.contains(Player().id);
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

  Null Function() _playCard() {
    if(_selectedCard == null) {
      return null;
    }

    return () {
      setState(() {
        _gameTable.playedCards.addAll(<String, String>{Player().id: _selectedCard.text});
        GameRepository().updateDocument(_gameTable);
        _cards.remove(_selectedCard);
        _selectedCard = null;
      });
    };
  }
}
