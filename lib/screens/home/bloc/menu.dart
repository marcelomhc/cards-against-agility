import 'package:cards_against_agility/components/general_dialog.dart';
import 'package:cards_against_agility/screens/home/components/about.dart';
import 'package:cards_against_agility/screens/home/components/dialogs.dart';
import 'package:cards_against_agility/screens/home/components/instructions.dart';
import 'package:flutter/cupertino.dart';

void handleClick(String value, BuildContext context) {
  switch (value) {
    case 'Change name':
      changeNameDialog(context);
      break;
    case 'How to play?':
      generalDialog(Instructions(), context);
      break;
    case 'About':
      generalDialog(About(), context);
      break;
  }
}
