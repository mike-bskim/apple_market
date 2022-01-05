import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:apple_market/src/pages/start/address_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  AddressPage({Key? key}) : super(key: key);

  final TextEditingController _addressController = TextEditingController();

  void onClickSearchAddress(){
    final text = _addressController.text;
    logger.d('text:' + text);
    if (text.isNotEmpty) {
      AddressService().searchAddressByStr(text);
    }
    logger.d('address_page >> on Text Button Clicked !!!');
  }


  @override
  Widget build(BuildContext context) {
    logger.d("AddressPage >> build");

    return SafeArea(
      minimum: const EdgeInsets.only(left: padding_16, right: padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey,),
              hintText: '도로명으로 검색',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
              prefixIconConstraints: const BoxConstraints(minWidth: 24, maxHeight: 24),
            ),
          ),
          TextButton.icon(
            onPressed: onClickSearchAddress,
            icon: const Icon(CupertinoIcons.compass, color: Colors.white, size: 20,),
            label: Text('현재위치 찾기',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: padding_16),
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
