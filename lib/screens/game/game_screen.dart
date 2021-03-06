import 'dart:async';

import 'package:cards_against_agility/components/general_dialog.dart';
import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/screens/game/components/card_widget.dart';
import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/bloc/game_repository.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/screens/game/components/exit_dialog.dart';
import 'package:cards_against_agility/screens/game/components/hand.dart';
import 'package:cards_against_agility/screens/game/components/message_box.dart';
import 'package:cards_against_agility/screens/game/components/score_dialog.dart';
import 'package:cards_against_agility/screens/game/model/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class GameScreen extends StatefulWidget {
  const GameScreen(this._table);

  final GameTable _table;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamSubscription<Map<String, dynamic>> listener;
  GameTable _game;

  void _gameListener(Map<String, dynamic> map) {
    _game = GameTable.fromMap(map);

    if(_game.lastVoted.isNotEmpty) {
      _game.lastVoted = <String, String>{};
      GameRepository().updateDocument(_game);
    }

    setState(() {
      if (_game.finished()) {
        Navigator.of(context).popUntil((Route route) => route.isFirst);
        Navigator.of(context).pushNamed('/results', arguments: _game);
      } else if(_game.allCardsPlayed()) {
        _game.lastVoted = <String, String>{};
        Navigator.of(context).pushNamed('/round', arguments: _game);
      }
    });
  }

  @override
  void initState() {
    _game = widget._table;
    listener = GameRepository().newListener(_game, _gameListener);
    super.initState();
  }

  @override
  void dispose() {
    _game.removePlayer(Player().id);
    GameRepository().updateDocument(_game);
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: WillPopScope(
                      onWillPop: _onWillPop,
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Text('Round ${_game.round} of $NUMBER_OF_ROUNDS', style: const TextStyle(fontWeight: FontWeight.bold),)
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.4,
                            child: CardWidget(card: GameCard(text: _game.blackCardText(), type: CardType.BLACK)),
                          ),
                          MessageBox(text: 'The host for this round is:\n' + _hostName(), color: SECONDARY_COLOR,),
                          Hand(_game),
                          Padding(
                            child: _revealCardsButton(),
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          ),
                          ElevatedButton(onPressed: () {generalDialog(ScoreWidget(child: _game), context);}, child: const Text('Show Score'))
                        ],
                      ),
                    )),
                constraints: const BoxConstraints(maxWidth: maxWidth),
            ))));
  }

  Widget _revealCardsButton() {
    if (_game.allCardsPlayed()) {
      return ElevatedButton(
        onPressed: () {Navigator.of(context).pushNamed('/round', arguments: _game);},
        child: const Text('Reveal Played Cards'),
      );
    } else {
      return OutlineButton(
        onPressed: null,
        child: Text('Waiting for more cards (Played: ' + _game.playedCards.length.toString() + '/' + (_game.players.length - 1).toString() + ')'),
      );
    }
  }

  String _hostName() {
    return Player().isPlayer(_game.host) ?
    Player().username + ' (You)'
        : _game.players[_game.host];
  }

  Future<bool> _onWillPop() {
    confirmExitDialog(context).then((int value) {
      switch (value) {
        case 1:
          Navigator.pop(context);
          break;
        case 0:
        default:
          break;
      }
    });
    return Future<bool>.value(false);
  }
}
