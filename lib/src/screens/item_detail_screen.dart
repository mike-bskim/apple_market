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

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  bool isAppbarCollapsed = false;
  Size? _size;
  num? _statusBarHeight;

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
    _scrollController.addListener(() {
      if (_size == null && _statusBarHeight == null) return;
      // logger.d(
      //     '${_scrollController.offset}, ${_size!.width - kToolbarHeight - _statusBarHeight!}, ${isAppbarCollapsed.toString()}');

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
                  // 메인 정보를 표시하는 영역
                  Scaffold(
                    // 화면 하단을 네비로 표시함
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '4000원',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    '가격제안불가',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              TextButton(
                                onPressed: () {},
                                child: const Text('채팅으로 거래하기'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 메인정보를 표시
                    body: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        // 업로드한 사진 정보를 표시하는 영역
                        _imageAppBar(itemModel),
                        // 상세 텍스트 정보를 표시하는 영역
                        SliverPadding(
                          padding: const EdgeInsets.all(padding_16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _userSection(),
                              _divider(padding_16 * 2 + 1),
                              Text(
                                '카즈미 캠핑키진 툴',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              _textGap,
                              Row(
                                children: [
                                  Text(
                                    '스포츠/레저',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(decoration: TextDecoration.underline),
                                  ),
                                  Text(
                                    ' · 2분전',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              _textGap,
                              Text(
                                '한번사용했어요\n'
                                '흠집이나 하자없고 깨긋합니다',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              _textGap,
                              Text(
                                '조회 33',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              _textGap,
                              _divider(2),
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '이 게시글 신고하기',
                                    // style: Theme.of(context)
                                    //     .textTheme
                                    //     .button!
                                    //     .copyWith(color: Colors.black87),
                                  ),
                                ),
                              ),
                              _divider(2),
                              // 판매자의 다른 상품 보기
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '무무님의 판매 상품',
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
                                          '더보기',
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
                            ]),
                          ),
                        ),
                        SliverGrid.count(
                            crossAxisCount: 2,
                            children: List.generate(
                              10,
                              (index) => Container(
                                color: Colors.accents[index],
                              ),
                            ))
                      ],
                    ),
                  ),
                  // 앱바 영역에 그라데이션 표현 추가
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
                  // 화면 스크롤업 하면 앱바를 힌색으로 변경.
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

  SliverAppBar _imageAppBar(ItemModel itemModel) {
    return SliverAppBar(
      expandedHeight: _size!.width,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // 인디케이터 표시
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
        // 이미지 표시
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

  Widget _userSection() {
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
                  width: 42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const FittedBox(
                        child: Text(
                          '37.3 °C',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
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
    );
  }
}
