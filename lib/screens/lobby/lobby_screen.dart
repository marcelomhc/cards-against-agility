import 'dart:async';

import 'package:cards_against_agility/bloc/game_repository.dart';
import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/models/game.dart';
import 'package:cards_against_agility/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen(this._table);

  final GameTable _table;

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  StreamSubscription<Map<String, dynamic>> listener;
  GameTable _gameTable;

  void _listen(Map<String, dynamic> map) {
    setState(() {
      _gameTable = GameTable.fromMap(map);
      if (_gameTable.round > 0) {
        listener.cancel();
        Navigator.of(context).pushReplacementNamed('/table', arguments: _gameTable);
      }
    });
  }

  @override
  void dispose() {
    if(_gameTable.waitingPlayers()) {
      _gameTable.removePlayer(Player().id);
    }
    GameRepository().updateDocument(_gameTable);
    listener.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _gameTable = widget._table;
    listener = GameRepository().newListener(_gameTable, _listen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards Against Agility'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Waiting for players...',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.hourglass_bottom_outlined,
              size: 130.0,
              color: secondaryColor,
            ),
            const Text(
              'To invite players use:',
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              _gameTable.id,
              style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              child: Column(
                  children: <Widget>[
                    const Text(
                      'Players joined:',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Text(_playerList(_gameTable.players.values))
                  ]
              ),
              padding: const EdgeInsets.all(20),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _startGame(),
                    child: Text(_startGameText()),
                  ),
                  Padding(
                      child: ElevatedButton(
                        onPressed: () { Navigator.pop(context); },
                        child: const Text('Exit'),
                      ),
                      padding: const EdgeInsets.only(left: 10.0)
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  String _startGameText() {
    return Player().isPlayer(_gameTable.host) ? 'Start game' : 'Waiting for host';
  }

  String _playerList(Iterable<String> players) {
    String text = '';
    for (final String player in players) {
      text += player + '\n';
    }
    return text;
  }

  Null Function() _startGame() {
    return Player().isPlayer(_gameTable.host) && _gameTable.players.length >= MIN_PLAYERS ?
      () {
        _gameTable.startGame();
        GameRepository().updateDocument(_gameTable);
      }
      : null;
  }
}
