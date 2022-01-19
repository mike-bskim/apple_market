import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/model/item_model.dart';
import 'package:apple_market/src/repo/item_service.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;

  const ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

// class _ItemDetailScreenState extends State<ItemDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     logger.d('item detail screen >> build >>> [${widget.itemKey}]');
//
//     return FutureBuilder<ItemModel>(
//       future: ItemService().getItem(widget.itemKey),
//       builder: (context, snapshot) {
//         if(snapshot.hasData){
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               Size _size = MediaQuery.of(context).size;
//
//               return Scaffold(
//                 body: CustomScrollView(
//                   slivers: [
//                     SliverAppBar(
//                       expandedHeight: _size.width,
//                       pinned: true,
//                       flexibleSpace: const FlexibleSpaceBar(
//                         title: Text(
//                           'testing',
//                           style: TextStyle(color: Colors.black87),
//                         ),
//                         background: FlutterLogo(),
//                       ),
//                     ),
//                     SliverToBoxAdapter(
//                       child: Container(
//                         height: _size.height * 2,
//                         color: Colors.blue,
//                         child: Center(child: Text('Item key is ${widget.itemKey}')),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         } else {
//           return Container(
//             child: const Center(child: Text("No data")),
//           );
//         }
//
//       }
//     );
//   }
// }

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // logger.d('item detail screen >> build >>> [${widget.itemKey}]');

    return FutureBuilder<ItemModel>(
      future: ItemService().getItem(widget.itemKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ItemModel itemModel = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              Size _size = MediaQuery.of(context).size;
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: _size.width,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              allowImplicitScrolling: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ExtendedImage.network(
                                  itemModel.imageDownloadUrls[index],
                                  fit: BoxFit.cover,
                                  scale: 0.1,
                                );
                              },
                              itemCount: itemModel.imageDownloadUrls.length,
                            ),
                            Positioned(
                              bottom: padding_16,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: SmoothPageIndicator(
                                    controller: _pageController,
                                    // PageController
                                    count: itemModel.imageDownloadUrls.length,
                                    effect: WormEffect(
                                      activeDotColor: Theme.of(context).primaryColor,
                                      dotColor: Theme.of(context).colorScheme.background,
                                      radius: 6,
                                      dotHeight: 12,
                                      dotWidth: 12,
                                    ),
                                    // your preferred effect
                                    onDotClicked: (index) {}),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: _size.height * 2,
                        color: Colors.cyan,
                        child: Center(child: Text('item key is${widget.itemKey}')),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
        return Container(
          child: const Center(child: Text('No data')),
        );
      },
    );
  }
}
