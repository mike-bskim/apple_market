import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  void onButtonClick(){
    logger.d('address_page >> on Text Button Clicked !!!');
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          TextButton.icon(
            icon: const Icon(CupertinoIcons.compass, color: Colors.white, size: 20,),
            onPressed: onButtonClick,
            label: Text('현재위치 찾기',
              style: Theme.of(context).textTheme.button,
            ),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size(10, 48),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              // shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ExtendedImage.asset('assets/imgs/apple.png'),
                  title: Text('title $index'),
                  subtitle:  Text('subtitle $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
