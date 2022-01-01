import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey,),
              border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
              prefixIconConstraints: const BoxConstraints(minWidth: 24, maxHeight: 24),
              hintText: '도로명으로 검색',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
        ],
      ),
    );
  }
}
