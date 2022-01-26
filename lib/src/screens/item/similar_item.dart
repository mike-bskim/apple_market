import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/model/item_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SimilarItem extends StatelessWidget {
  final ItemModel _itemModel;
  const SimilarItem(this._itemModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AspectRatio(
          aspectRatio: 5/4,
          child: ExtendedImage.network(
            _itemModel.imageDownloadUrls[0],
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
          ),
        ),
        Text(
          _itemModel.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: padding_08),
          child: Text('${_itemModel.price.toString()}원',style: Theme.of(context).textTheme.subtitle2,),
        ),
      ],
    );
  }
}
