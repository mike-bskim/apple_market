import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/model/chatroom_model.dart';
import 'package:apple_market/src/model/item_model.dart';
import 'package:apple_market/src/model/user_model.dart';
import 'package:apple_market/src/repo/chat_service.dart';
import 'package:apple_market/src/repo/item_service.dart';
import 'package:apple_market/src/router/locations.dart';
import 'package:apple_market/src/screens/item/similar_item.dart';
import 'package:apple_market/src/states/category_notifier.dart';
import 'package:apple_market/src/states/user_notifier.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:apple_market/src/utils/time_calculation.dart';
import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;

  const ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  bool isAppbarCollapsed = false;
  Size? _size;
  num? _statusBarHeight;
  late String newItemKey;

  final Widget _textGap = const SizedBox(height: padding_16);

  Widget _divider(double _height) {
    return Divider(
      height: _height, //padding_16 * 2 + 1,
      thickness: 2,
      color: Colors.grey[300]!,
      // indent: padding_08,
      // endIndent: padding_08,
    );
  }

  @override
  void initState() {
    newItemKey = widget.itemKey;
    if (widget.itemKey[0] == ':') {
      // String orgItemKey = widget.itemKey;
      newItemKey = widget.itemKey.substring(1);
    }

    _scrollController.addListener(() {
      if (_size == null && _statusBarHeight == null) return;
      // logger.d(
      //     '${_scrollController.offset}, ${_size!.width - kToolbarHeight - _statusBarHeight!}, ${isAppbarCollapsed.toString()}');

      if (isAppbarCollapsed) {
        if (_scrollController.offset <
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        }
      } else {
        if (_scrollController.offset >
            _size!.width - kToolbarHeight - _statusBarHeight!) {
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

  void _goToChatroom(ItemModel itemModel, UserModel userModel) async {
    String chatroomKey =
        ChatroomModel.generateChatRoomKey(userModel.userKey, newItemKey);
    logger.d({
      'buyerKey' : '[${userModel.userKey}]',
      'sellerKey' : '[${itemModel.userKey}]',
      'newItemKey' : '[$newItemKey]'
    });

    ChatroomModel _chatroomModel = ChatroomModel(
      itemImage: itemModel.imageDownloadUrls[0],
      itemTitle: itemModel.title,
      itemKey: newItemKey,
      itemAddress: itemModel.address,
      itemPrice: itemModel.price,
      sellerKey: itemModel.userKey,
      buyerKey: userModel.userKey,
      sellerImage: 'https://minimaltoolkit.com/images/randomdata/male/101.jpg',
      buyerImage: 'https://minimaltoolkit.com/images/randomdata/female/41.jpg',
      geoFirePoint: itemModel.geoFirePoint,
      chatroomKey: chatroomKey,
      lastMsgTime: DateTime.now(),
    );
    await ChatService().createNewChatroom(_chatroomModel);

    context.beamToNamed('/$LOCATION_ITEM/:$newItemKey/:$chatroomKey');
  }

  @override
  Widget build(BuildContext context) {
    logger.d('item detail screen >> build >>> [$newItemKey]');

    return FutureBuilder<ItemModel>(
      future: ItemService().getItem(newItemKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // FutureBuilder ??? snapshot ?????? ????????? ????????? ????????????
          ItemModel itemModel = snapshot.data!;
          // provider ??????????????? ?????? ????????? ????????????
          UserModel userModel = context.read<UserNotifier>().userModel!;

          return LayoutBuilder(
            builder: (context, constraints) {
              _size = MediaQuery.of(context).size;
              _statusBarHeight = MediaQuery.of(context).padding.top;
              return Stack(
                fit: StackFit.expand,
                children: [
                  // ?????? ????????? ???????????? ??????
                  Scaffold(
                    // ?????? ????????? ????????? ?????????
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
                                icon: const Icon(Icons.favorite_border),
                              ),
                              const VerticalDivider(
                                thickness: 1,
                                width: padding_08 * 2 + 1,
                                indent: padding_08,
                                endIndent: padding_08,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemModel.price.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    itemModel.negotiable ? '??????????????????' : '??????????????????',
                                    style: itemModel.negotiable
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.blue)
                                        : Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              TextButton(
                                onPressed: () {
                                  _goToChatroom(itemModel, userModel);
                                },
                                child: const Text('???????????? ????????????'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ??????????????? ??????
                    body: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        // ???????????? ?????? ????????? ???????????? ??????
                        _imageAppBar(itemModel),
                        // ?????? ????????? ????????? ???????????? ??????
                        SliverPadding(
                          padding: const EdgeInsets.all(padding_16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _userSection(itemModel),
                              _divider(padding_16 * 2 + 1),
                              Text(
                                itemModel.title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              _textGap,
                              Row(
                                children: [
                                  Text(
                                    categoriesMapEngToKor[itemModel.category] ??
                                        '??????',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                  Text(
                                    ' ?? ${TimeCalculation.getTimeDiff(itemModel.createdDate)}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              _textGap,
                              Text(
                                itemModel.detail,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              _textGap,
                              Text(
                                '?????? 33',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              _textGap,
                              _divider(2),
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  // ???????????? ???????????? ????????? flutter_email_sender ????????? ???
                                  // https://pub.dev/packages/flutter_email_sender
                                  logger.d('???????????? ???????????????');
                                },
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '??? ????????? ????????????',
                                    // style: Theme.of(context)
                                    //     .textTheme
                                    //     .button!
                                    //     .copyWith(color: Colors.black87),
                                  ),
                                ),
                              ),
                              _divider(2),
                              // ???????????? ?????? ?????? ??????
                            ]),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: padding_16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '???????????? ?????? ??????',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  width: _size!.width / 4,
                                  child: MaterialButton(
                                    // padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '?????????',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: FutureBuilder<List<ItemModel>>(
                            future: ItemService().getUserItems(
                                itemModel.userKey,
                                itemKey: itemModel.itemKey),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(padding_08),
                                  child: GridView.count(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: padding_08),
                                    //EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: padding_08,
                                    crossAxisSpacing: padding_08,
                                    childAspectRatio: 6 / 7,
                                    children: List.generate(
                                        snapshot.data!.length,
                                        (index) =>
                                            SimilarItem(snapshot.data![index])),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ?????? ????????? ??????????????? ?????? ??????
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
                  // ?????? ???????????? ?????? ????????? ???????????? ??????.
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
                        foregroundColor:
                            isAppbarCollapsed ? Colors.black87 : Colors.white,
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

  SliverAppBar _imageAppBar(ItemModel itemModel) {
    return SliverAppBar(
      expandedHeight: _size!.width,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // ??????????????? ??????
        title: SizedBox(
          child: SmoothPageIndicator(
              controller: _pageController,
              // PageController
              count: itemModel.imageDownloadUrls.length,
              effect: const WormEffect(
                activeDotColor: Colors.white,
                //Theme.of(context).primaryColor,
                dotColor: Colors.white24,
                //Theme.of(context).colorScheme.background,
                radius: 3,
                dotHeight: 6,
                dotWidth: 6,
              ),
              // your preferred effect
              onDotClicked: (index) {}),
        ),
        // ????????? ??????
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
    );
  }

  Widget _userSection(ItemModel _itemModel) {
    int phoneCnt = _itemModel.userPhone.length;
    //[???????????????, ?????????, ?????????71???, 11, (?????????2???)]
    //[???????????????, ??????, ?????????1???, 31]
    List _address = _itemModel.address.split(' ');
    String _detail = _address[_address.length - 1];
    String _location = '';

    if (_detail.contains('(') && _detail.contains(')')) {
      _location = _detail.replaceAll('(', '').replaceAll(')', '');
    } else {
      _location = _address[2];
    }

    return Row(
      children: [
        ExtendedImage.network(
          'https://picsum.photos/50',
          fit: BoxFit.cover,
          width: _size!.width / 10,
          height: _size!.width / 10,
          shape: BoxShape.circle,
        ),
        const SizedBox(width: padding_16),
        SizedBox(
          height: _size!.width / 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _itemModel.userPhone.substring(phoneCnt - 4).toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                _location,
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
                  width: 42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const FittedBox(
                        child: Text(
                          '37.3 ??C',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 6),
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
                const SizedBox(width: 6),
                const ImageIcon(
                  ExtendedAssetImageProvider('assets/imgs/happiness.png'),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: padding_08),
            Text(
              '????????????',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ],
        ),
        // Text('aaa'),
      ],
    );
  }
}
