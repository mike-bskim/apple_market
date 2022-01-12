import 'package:apple_market/src/constants/common_size.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MultiImageSelect extends StatelessWidget {
  const MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;
        var imgSize = (_size.width / 3) - padding_16 * 2;

        return SizedBox(
          height: _size.width / 3,
          // width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(padding_16),
                child: Container(
                  width: imgSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(padding_16),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_rounded, color: Colors.grey),
                      Text('0/10', style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              ),
              ...List.generate(
                20,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: padding_16, top: padding_16, bottom: padding_16),
                  child: ExtendedImage.network(
                    'https://picsum.photos/100',
                    width: imgSize,
                    height: imgSize,
                    borderRadius: BorderRadius.circular(padding_16),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
