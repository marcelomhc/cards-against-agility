import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(15.0),
        children: <Widget>[
          const Text('About', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          const Text('Version 0.1.0\n', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0), textAlign: TextAlign.end,),
          RichText(
            text: TextSpan(
              text: 'Thanks for playing!\n\n',
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                const TextSpan(text: 'This is a beta version, your feedback is very welcome! \n\nIf you have comments, questions, suggestions, want to report an issue or want to help development, you can find the project in '),
                TextSpan(
                    text: 'GitHub',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL();
                      }
                    ),
                const TextSpan(text: ', you can get in contact there.\n\nHope you have fun playing!\n'),
              ]
            ),
          ),
          ElevatedButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: const Text('Close'),
          )
        ]
    );
  }

  Future<void> _launchURL() async {
    const String url = 'https://github.com/marcelomhc/cards-against-agility';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
