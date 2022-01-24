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
  final ScrollController _scrollController = ScrollController();

  bool isAppbarCollapsed = false;
  Size? _size;
  num? _statusBarHeight;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_size == null && _statusBarHeight == null) return;
      logger.d(
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
                    bottomNavigationBar: SafeArea(
                      top: false,
                      bottom: true,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey[300]!),
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(padding_08),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border),
                              ),
                              VerticalDivider(
                                thickness: 1,
                                width: padding_08 * 2 + 1,
                                indent: padding_08,
                                endIndent: padding_08,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('4000원', style: Theme.of(context).textTheme.bodyText1,),
                                  Text('가격제안불가', style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              ),
                              Expanded(child: Container()),
                              TextButton(
                                onPressed: () {},
                                child: Text('채팅으로 거래하기'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                        SliverList(
                            delegate: SliverChildListDelegate([
                          _userSection(),
                        ]))
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
                        backgroundColor: isAppbarCollapsed ? Colors.white : Colors.transparent,
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

  Widget _userSection() {
    return Padding(
      padding: const EdgeInsets.all(padding_08),
      child: Row(
        children: [
          ExtendedImage.network(
            'https://picsum.photos/50',
            fit: BoxFit.cover,
            width: _size!.width / 10,
            height: _size!.width / 10,
            shape: BoxShape.circle,
          ),
          SizedBox(width: padding_16),
          SizedBox(
            height: _size!.width / 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '무무',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  '원효로',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FittedBox(
                          child: Text(
                            '37.3',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                        ),
                        SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1),
                          child: LinearProgressIndicator(
                            color: Colors.blueAccent,
                            value: 0.365,
                            minHeight: 3,
                            backgroundColor: Colors.grey[200],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  const ImageIcon(
                    ExtendedAssetImageProvider('assets/imgs/happiness.png'),
                    color: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: padding_08),
              Text(
                '매너온도',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ],
          ),
          // Text('aaa'),
        ],
      ),
    );
  }
}
