import 'package:apple_market/src/screens/home_screen.dart';
import 'package:apple_market/src/screens/input/category_input_screen.dart';
import 'package:apple_market/src/screens/input_screen.dart';
import 'package:apple_market/src/states/category_notifier.dart';
import 'package:apple_market/src/states/select_image_notifier.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [BeamPage(key: const ValueKey('home'), child: const HomeScreen())];
  }

  @override
  List get pathBlueprints => ['/'];

// @override
// // TODO: implement pathPatterns
// List<Pattern> get pathPatterns => ['/'];
}

class InputLocation extends BeamLocation {
  // @override
  // Widget builder(BuildContext context, Widget navigator) {
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider.value(value: categoryNotifier),
  //       ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
  //     ],
  //     child: super.builder(context, navigator),
  //   );
  // }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [
      ...HomeLocation().buildPages(context, state), // 이게 없으면 input 페이지에서 back 버튼이 안생김
      if (state.pathBlueprintSegments.contains('input'))
        // BeamPage(key: const ValueKey('input'), child: const InputScreen()),
      BeamPage(
        key: const ValueKey('input'),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: categoryNotifier),
            ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
          ],
          child: const InputScreen(),
        ),
      ),
      if (state.pathBlueprintSegments.contains('category_input'))
        // BeamPage(key: const ValueKey('category_input'), child: const CategoryInputScreen()),
      BeamPage(
        key: const ValueKey('category_input'),
        child: ChangeNotifierProvider.value(
            value: categoryNotifier, child: const CategoryInputScreen()),
      ),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<String> get pathBlueprints => ['/input', '/input/category_input'];
}
