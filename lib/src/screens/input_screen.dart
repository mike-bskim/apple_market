import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/model/item_model.dart';
import 'package:apple_market/src/screens/input/multi_image_select.dart';
import 'package:apple_market/src/states/category_notifier.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final dividerCustom = Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey[350],
    indent: padding_16,
    endIndent: padding_16,
  );

  final underLineBorder =
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  bool _suggestPriceSelected = false;
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            logger.d('뒤로가기 버튼 클릭');
            context.beamBack();
            // Navigator.of(context).pop();
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
              //context.beamBack();
              // Navigator.of(context).pop();
              ItemModel itemModel = ItemModel(
                itemKey: itemKey,
                userKey: userKey,
                imageDownloadUrls: imageDownloadUrls,
                title: title,
                category: category,
                price: price,
                negotiable: negotiable,
                detail: detail,
                address: address,
                geoFirePoint: geoFirePoint,
                createdDate: createdDate,
              );
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
          // 멀티 이미지 영역
          const MultiImageSelect(),
          dividerCustom,
          // 제목영역
          TextFormField(
            decoration: InputDecoration(
              hintText: '글제목',
              contentPadding: const EdgeInsets.symmetric(horizontal: padding_16),
              border: underLineBorder,
              enabledBorder: underLineBorder,
              focusedBorder: underLineBorder,
            ),
          ),
          dividerCustom,
          // 카타고리 영역
          ListTile(
            onTap: () {
              context.beamToNamed('/input/category_input');
            },
            dense: true,
            title: Text(context.watch<CategoryNotifier>().currentCategoryInKor),
            trailing: const Icon(Icons.navigate_next),
          ),
          dividerCustom,
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: padding_16),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    onChanged: (value) {
                      if ('0 원' == value) {
                        _priceController.clear();
                      }
                      setState(() {});
                    },
                    inputFormatters: [MoneyInputFormatter(mantissaLength: 0, trailingSymbol: ' 원')],
                    decoration: InputDecoration(
                      hintText: '가격',
                      prefixIcon: ImageIcon(
                        const ExtendedAssetImageProvider('assets/imgs/won.png'),
                        color: (_priceController.text.isEmpty) ? Colors.grey[350] : Colors.black87,
                      ),
                      prefixIconConstraints: const BoxConstraints(maxWidth: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: padding_08),
                      border: underLineBorder,
                      enabledBorder: underLineBorder,
                      focusedBorder: underLineBorder,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: padding_16),
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _suggestPriceSelected = !_suggestPriceSelected;
                    });
                  },
                  icon: Icon(
                    _suggestPriceSelected ? Icons.check_circle : Icons.check_circle_outline,
                    color: _suggestPriceSelected ? Theme.of(context).primaryColor : Colors.black54,
                  ),
                  label: Text(
                    '가격제안 받기',
                    style: TextStyle(
                      color:
                          _suggestPriceSelected ? Theme.of(context).primaryColor : Colors.black54,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    primary: Colors.black45,
                  ),
                ),
              )
            ],
          ),
          dividerCustom,
          // 올릴 게시글 내용을 작성
          TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: '올릴 게시글 내용을 작성해주세요',
              contentPadding: const EdgeInsets.symmetric(horizontal: padding_16),
              border: underLineBorder,
              enabledBorder: underLineBorder,
              focusedBorder: underLineBorder,
            ),
          ),
        ],
      ),
    );
  }
}
