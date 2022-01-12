import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            context.beamBack();
          },
          style: TextButton.styleFrom(backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
          child: Text(
            '뒤로',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.beamBack();
            },
            style: TextButton.styleFrom(backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
            child: Text(
              '완료',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
        title: Text('중고거래 등록', style: Theme.of(context).textTheme.headline6,),
      ),
      body: Container(
        color: Colors.yellowAccent,
      ),
    );
  }
}
