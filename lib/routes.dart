import 'package:cards_against_agility/models/game.dart';
import 'package:flutter/material.dart';

import 'screens/game/game_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/lobby/lobby_screen.dart';
import 'screens/results/results_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => HomeScreen(),
  '/lobby': (BuildContext context) => LobbyScreen(ModalRoute.of(context).settings.arguments as GameTable),
  '/table': (BuildContext context) => GameScreen(ModalRoute.of(context).settings.arguments as GameTable),
  '/results': (BuildContext context) => ResultsScreen(ModalRoute.of(context).settings.arguments as GameTable)
};
