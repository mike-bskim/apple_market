import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/screens/input/multi_image_select.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  final dividerCustom = Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey[300],
    indent: padding_16,
    endIndent: padding_16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            context.beamBack();
          },
          style:
              TextButton.styleFrom(backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
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
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
            child: Text(
              '완료',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
        title: Text(
          '중고거래 등록',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: ListView(
        children: <Widget>[
          const MultiImageSelect(),
          dividerCustom,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding_16),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: '글제목',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          dividerCustom,
          const ListTile(
            dense: true,
            title: Text('선택'),
            trailing: Icon(Icons.navigate_next),
          ),
          dividerCustom,
          
        ],
      ),
    );
  }
}
