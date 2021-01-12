import 'dart:async';

import 'package:cards_against_agility/screens/game/components/card_widget.dart';
import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/bloc/game_repository.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/screens/game/components/exit_dialog.dart';
import 'package:cards_against_agility/screens/game/components/hand.dart';
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
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: WillPopScope(
                  onWillPop: _onWillPop,
                  child: ListView(
                    children: <Widget>[
                      CardWidget(card: GameCard(text: _game.blackCardText(), type: CardType.BLACK)),
                      Hand(_game),
                      Padding(
                        child: _revealCardsButton(),
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      ),
                      ElevatedButton(onPressed: () {dialog(ScoreWidget(child: _game));}, child: const Text('Show Score'))
                    ],
                  ),
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

  void dialog(Widget content) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (BuildContext context, Animation<double> a1, Animation<double> a2, Widget widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                content: content,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) { return null;}
    );
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
