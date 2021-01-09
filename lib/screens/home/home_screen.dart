import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/screens/home/bloc/menu.dart';
import 'package:cards_against_agility/screens/home/components/dialogs.dart';
import 'package:flutter/material.dart';

import 'bloc/load_game.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_TITLE),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) { handleClick(value, context); },
            itemBuilder: (BuildContext context) {
              return <String>{'Change name', 'How to play?', 'About'}.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person,
              size: 130.0,
              color: secondaryColor,
            ),
            Text(
              Player().username,
              style: const TextStyle(fontSize: 15.0),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () { joinGameDialog(context); },
                    child: const Text('Join game'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      onPressed: () { createGame(context); },
                      child: const Text('Create new game'),
                    ),
                  )
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}
