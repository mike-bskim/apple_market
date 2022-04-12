import 'package:apple_market/src/utils/logger.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[200]!));

  final underBorderStyle = const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent));

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Center(
            // child: TextField(
            //   controller: _textEditingController,
            //   textAlignVertical: TextAlignVertical.bottom,
            //   decoration: InputDecoration(
            //         isDense: true,
            //         fillColor: Colors.grey[100],
            //         contentPadding:
            //             const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            //         // EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
            //         filled: true,
            //         hintText: '아이템 검색 TextField',
            //         border: borderStyle,
            //         focusedBorder: underBorderStyle,
            //   ),
            // ),
            child: TextFormField(
              controller: _textEditingController,
              onFieldSubmitted: (value) {
                logger.d('onFieldSubmitted clicked >> ' + value.toString());
                setState(() {});
              },
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                // EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                filled: true,
                hintText: '아이템 검색',
                // border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: underBorderStyle,
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_textEditingController.text),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1.0,
              height: 4.0,
            );
          },
          itemCount: 10),
    );
  }
}
