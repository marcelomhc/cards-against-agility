import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({this.text, this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 5.0, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color.withOpacity(0.5),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Text(text, textAlign: TextAlign.center,)
        ),
      ),
    );
  }
}
