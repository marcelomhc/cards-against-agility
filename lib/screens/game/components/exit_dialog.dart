import 'package:cards_against_agility/models/constants.dart';
import 'package:flutter/material.dart';

Future<int> confirmExitDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        contentPadding:
        const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            height: 100.0,
            color: PRIMARY_COLOR,
            child: Column(
              children: <Widget>[
                Container(
                  child: const Icon(Icons.exit_to_app, size: 30.0, color: Colors.black),
                  margin: const EdgeInsets.only(bottom: 10.0),
                ),
                const Text('Exit table', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                const Text('Are you sure to leave this table?', style: TextStyle(color: Colors.black, fontSize: 14.0)),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () { Navigator.pop(context, 0); },
            child: Row(
              children: <Widget>[
                Container(
                  child: const Icon(Icons.cancel, color: Colors.red),
                  margin: const EdgeInsets.only(right: 10.0),
                ),
                const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () { Navigator.pop(context, 1); },
            child: Row(
              children: <Widget>[
                Container(
                  child: const Icon(Icons.check_circle, color: Colors.green),
                  margin: const EdgeInsets.only(right: 10.0),
                ),
                const Text('YES', style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      );
    }
  );
}
