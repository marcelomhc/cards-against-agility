import 'dart:async';

import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/components/game_repository.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/screens/game/components/exit_dialog.dart';
import 'package:cards_against_agility/screens/game/components/hand.dart';
import 'package:cards_against_agility/screens/game/components/played_cards.dart';
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
    setState(() {
      _game = GameTable.fromMap(map);
      if (_game.finished()) {
        Navigator.of(context).pushReplacementNamed('/results', arguments: _game);
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
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          width: MediaQuery.of(context).size.width / 3,
                          child: AspectRatio(
                            aspectRatio: 0.9,
                              child: GameCard(text: blackCards[_game.blackCard.last], type: CardType.BLACK).widget(),
                          ),
                        ),
                      ),
                      PlayedCards(_game),
                      Hand(_game),
                    ],
                  ),
                ))));
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
