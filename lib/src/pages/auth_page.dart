import 'package:apple_market/src/pages/start/intro_page.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          const IntroPage(),
          Container(
            color: Colors.accents[2],
          ),
          Container(
            color: Colors.accents[5],
          ),
        ],
      ),
    );
  }
}
