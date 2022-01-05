import 'package:apple_market/src/pages/start/address_page.dart';
import 'package:apple_market/src/pages/start/auth_page.dart';
import 'package:apple_market/src/pages/start/intro_page.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // physics: const NeverScrollableScrollPhysics(), // 사용자가 스크롤하지 못하게 설정
        controller: _pageController,
        children: <Widget>[
          IntroPage(_pageController),
          const AddressPage(),
          const AuthPage(),
        ],
      ),
    );
  }
}
