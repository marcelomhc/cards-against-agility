import 'package:cards_against_agility/screens/home/components/dialogs.dart';
import 'package:flutter/cupertino.dart';

void handleClick(String value, BuildContext context) {
  switch (value) {
    case 'Change name':
      changeNameDialog(context);
      break;
    case 'Help':
      break;
  }
}
