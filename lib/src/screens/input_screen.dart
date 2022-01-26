import 'dart:typed_data';

import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/model/item_model.dart';
import 'package:apple_market/src/repo/image_storage.dart';
import 'package:apple_market/src/repo/item_service.dart';
import 'package:apple_market/src/router/locations.dart';
import 'package:apple_market/src/screens/input/multi_image_select.dart';
import 'package:apple_market/src/states/category_notifier.dart';
import 'package:apple_market/src/states/select_image_notifier.dart';
import 'package:apple_market/src/states/user_notifier.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isCreatingItem = false;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void attemptCreateItem() async {
    if(FirebaseAuth.instance.currentUser == null) return;
    // 완료 버튼 클릭
    // Navigator.of(context).pop();
    isCreatingItem = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String itemKey = ItemModel.generateItemKey(userKey);
    List<Uint8List> images = context.read<SelectImageNotifier>().images;
    List<String> downloadUrls = await ImageStorage.uploadImage(images, itemKey);
    // final num? price = num.tryParse(_priceController.text.replaceAll('.', '').replaceAll(' 원', ''));
    final num? price = num.tryParse(_priceController.text.replaceAll(RegExp(r'\D'), ''));
    UserNotifier userNotifier = context.read<UserNotifier>();

    if(userNotifier.userModel == null) {
      return ;
    }
    // logger.d(downloadUrls);

    ItemModel itemModel = ItemModel(
      itemKey: itemKey,
      userKey: userKey,
      imageDownloadUrls: downloadUrls,
      title: _titleController.text,
      category: context.read<CategoryNotifier>().currentCategoryInEng,
      price: price??0,
      negotiable: _suggestPriceSelected,
      detail: _detailController.text,
      address: userNotifier.userModel!.address,
      geoFirePoint: userNotifier.userModel!.geoFirePoint,
      createdDate: DateTime.now().toUtc(),
    );

    await ItemService().createNewItem(itemModel, itemKey, userNotifier.user!.uid);

    context.beamBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: TextButton(
                onPressed: () {
                  logger.d('뒤로가기 버튼 클릭');
                  context.beamBack();
                },
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: Text(
                  '뒤로',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size(_size.width, 2),
                child: isCreatingItem? const LinearProgressIndicator(minHeight: 2,) : Container(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: attemptCreateItem,
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  child: Text(
                    '완료',
                    style: Theme.of(context).textTheme.bodyText1,
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
                  controller: _titleController,
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
                    context.beamToNamed('/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT');
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
                          inputFormatters: [
                            MoneyInputFormatter(mantissaLength: 0, trailingSymbol: ' 원')
                          ],
                          decoration: InputDecoration(
                            hintText: '가격',
                            prefixIcon: ImageIcon(
                              const ExtendedAssetImageProvider('assets/imgs/won.png'),
                              color:
                              (_priceController.text.isEmpty) ? Colors.grey[350] : Colors.black87,
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
                          color:
                          _suggestPriceSelected ? Theme.of(context).primaryColor : Colors.black54,
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
                  controller: _detailController,
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
          ),
        );
      },
    );
  }
}
