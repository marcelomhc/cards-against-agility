import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/screens/home/bloc/load_game.dart';
import 'package:flutter/material.dart';

void showLoaderDialog(BuildContext context){
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: <Widget>[
            const CircularProgressIndicator(),
            Container(margin: const EdgeInsets.only(left: 7), child: const Text('Loading...' )),
          ],
        ),
      );
    },
  );
}

void showErrorDialog(BuildContext context, String text){
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: Row(
            children: <Widget>[
              const Icon(Icons.warning, color: Colors.amber),
              Container(margin: const EdgeInsets.only(left: 7), child: Text(text)),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () { Navigator.pop(context); },
            )
          ]
      );
    },
  );
}

Future<void> joinGameDialog(BuildContext context) async {
  String gameCode;

  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(12.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onChanged: (String textTyped) {
                  gameCode = textTyped;
                },
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Game code'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {Navigator.pop(context);}
          ),
          FlatButton(
              child: const Text('JOIN'),
              onPressed: () { searchGame(context, gameCode); }
          ),
        ],
      );
    },
  );
}
Future<void> changeNameDialog(BuildContext context) async {
  String newName;

  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(12.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onChanged: (String textTyped) {
                  newName = textTyped;
                },
                autofocus: true,
                decoration: const InputDecoration(labelText: 'New username'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {Navigator.pop(context);}
          ),
          FlatButton(
              child: const Text('OK'),
              onPressed: () { Player().setName(newName); Navigator.of(context).pushReplacementNamed('/'); }
          ),
        ],
      );
    },
  );
}

void showInstructionsDialog() {

}
