import 'package:apple_market/src/constants/common_size.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;

        return ListView.separated(
          padding: const EdgeInsets.all(padding_16),
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1,
              color: Colors.black26,
              height: padding_16 * 2 + 1,
              indent: padding_16,
              endIndent: padding_16,
            );
          },
          itemCount: 10,
          itemBuilder: (context, index) {
            return SizedBox(
              height: imgSize,
              child: Row(
                children: <Widget>[
                  SizedBox(
                      height: imgSize,
                      width: imgSize,
                      child: ExtendedImage.network(
                        'https://picsum.photos/100',
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                  const SizedBox(
                    width: padding_16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'work',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          '53일전',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text('5000원'),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 16,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Row(
                                  children: const [
                                    Icon(
                                      CupertinoIcons.chat_bubble_2,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '23',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Icon(
                                      CupertinoIcons.heart,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '123',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
