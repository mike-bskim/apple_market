import 'package:apple_market/src/model/item_model.dart';
import 'package:apple_market/src/repo/item_service.dart';
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
  final ScrollController _scrollController = ScrollController();

  bool isAppbarCollapsed = false;
  Size? _size;
  num? _statusBarHeight;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_size == null && _statusBarHeight == null) return;
      print(
          '${_scrollController.offset}, ${_size!.width - kToolbarHeight - _statusBarHeight!}, ${isAppbarCollapsed.toString()}');

      if (isAppbarCollapsed) {
        if (_scrollController.offset < _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        }
      } else {
        if (_scrollController.offset > _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
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
              _size = MediaQuery.of(context).size;
              _statusBarHeight = MediaQuery.of(context).padding.top;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Scaffold(
                    body: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: _size!.width,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: SizedBox(
                              child: SmoothPageIndicator(
                                  controller: _pageController,
                                  // PageController
                                  count: itemModel.imageDownloadUrls.length,
                                  effect: WormEffect(
                                    activeDotColor: Theme.of(context).primaryColor,
                                    dotColor: Theme.of(context).colorScheme.background,
                                    radius: 3,
                                    dotHeight: 6,
                                    dotWidth: 6,
                                  ),
                                  // your preferred effect
                                  onDotClicked: (index) {}),
                            ),
                            background: PageView.builder(
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
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: _size!.height * 2,
                            color: Colors.cyan,
                            child: Center(child: Text('item key is ${widget.itemKey}')),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: kToolbarHeight + _statusBarHeight!,
                    child: Container(
                      height: kToolbarHeight + _statusBarHeight!,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                                  Colors.black45,
                                  Colors.black38,
                                  Colors.black26,
                                  Colors.black12,
                                  Colors.transparent,
                                ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: kToolbarHeight + _statusBarHeight!,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        shadowColor: Colors.transparent,
                        backgroundColor: isAppbarCollapsed
                            ? Colors.white
                            : Colors.transparent,
                        foregroundColor: isAppbarCollapsed ? Colors.black87 : Colors.white,
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }
        return Container(
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
