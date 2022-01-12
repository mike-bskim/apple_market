import 'package:apple_market/src/screens/start/address_page.dart';
import 'package:apple_market/src/screens/start/auth_page.dart';
import 'package:apple_market/src/screens/start/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider<PageController>.value(
      value: _pageController,
      child: Scaffold(
        body: PageView(
          // physics: const NeverScrollableScrollPhysics(), // 사용자가 스크롤하지 못하게 설정
          controller: _pageController,
          children: const <Widget>[
            IntroPage(),
            AddressPage(),
            AuthPage(),
          ],
        ),
      ),
    );
  }
}
