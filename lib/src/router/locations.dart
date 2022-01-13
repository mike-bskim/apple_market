import 'package:apple_market/src/screens/home_screen.dart';
import 'package:apple_market/src/screens/input/category_input_screen.dart';
import 'package:apple_market/src/screens/input_screen.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [const BeamPage(key: ValueKey('home'), child: HomeScreen())];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/'];
}

class InputLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [
      ...HomeLocation().buildPages(context, state), // 이게 없으면 input 페이지에서 back 버튼이 안생김
      if (state.pathPatternSegments.contains('input'))
        const BeamPage(key: ValueKey('input'), child: InputScreen()),
      if (state.pathPatternSegments.contains('category_input'))
        const BeamPage(key: ValueKey('category_input'), child: CategoryInputScreen()),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/input', '/input/category_input'];
}
