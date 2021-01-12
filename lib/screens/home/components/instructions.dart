import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(15.0),
        children: <Widget>[
          const Text('How to play', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          const Text('\nTo start a game you need a minimum of 3 players (but the more, the merrier!). \n\n'
            'At the beginning, each player will receive 7 cards with different terms related to Agile Software Development. In each round one black card is randomly selected with a text and a blank spot. \n\n'
            'One player will be the "host" while all others have to select a card that fills the blank spot in the funniest way possible. The host will select the funniest card and the player that played that card wins one point. \n\n'
            'The game last for 7 rounds and the player that has the most points at the end is considered the winner!\n\nHave fun!\n'),
          ElevatedButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: const Text('Close'),
          )
        ]
    );
  }
}
