import 'package:apple_market/src/constants/common_size.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SimilarItem extends StatelessWidget {
  const SimilarItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AspectRatio(
          aspectRatio: 5/4,
          child: ExtendedImage.network(
            'https://picsum.photos/100',
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
          ),
        ),
        Text(
          '어에메트 튜라빔 플러스 아주 좋아요',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: padding_08),
          child: Text('5000원',style: Theme.of(context).textTheme.subtitle2,),
        ),
      ],
    );
  }
}
