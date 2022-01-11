import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/repo/user_service.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;

        return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 2)),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: (snapshot.connectionState != ConnectionState.done)
                    ? _shimmerListView(imgSize)
                    : _listView(imgSize),
              );
            });
      },
    );
  }

  ListView _listView(double imgSize) {
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
        return InkWell(
          onTap: () {
            logger.d('UserService().firestore >>>');
            UserService().fireStoreReadTest();
          },
          child: SizedBox(
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
                      Text('work', style: Theme.of(context).textTheme.subtitle1),
                      Text('53일전', style: Theme.of(context).textTheme.subtitle2),
                      Text('${index + 5000}원'),
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
                                  Icon(CupertinoIcons.chat_bubble_2, color: Colors.grey),
                                  Text('23', style: TextStyle(color: Colors.grey)),
                                  Icon(CupertinoIcons.heart, color: Colors.grey),
                                  Text('123', style: TextStyle(color: Colors.grey)),
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
          ),
        );
      },
    );
  }

  Widget _shimmerListView(double imgSize) {
    var _containerDeco = BoxDecoration(
        shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(15.0));

    _containerSample(double _width) {
      return Container(height: 16, width: _width, decoration: _containerDeco);
    }

    return Shimmer.fromColors(
      highlightColor: Colors.grey[100]!,
      enabled: true,
      baseColor: Colors.grey[300]!,
      child: ListView.separated(
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
                Container(height: imgSize, width: imgSize, decoration: _containerDeco),
                const SizedBox(
                  width: padding_16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _containerSample(100),
                      const SizedBox(height: 8),
                      _containerSample(70),
                      const SizedBox(height: 8),
                      _containerSample(130),
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(height: 16, width: 100, decoration: _containerDeco),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
