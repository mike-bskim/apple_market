import 'package:apple_market/src/screens/chat/chatroom_screen.dart';
import 'package:apple_market/src/screens/home_screen.dart';
import 'package:apple_market/src/screens/input/category_input_screen.dart';
import 'package:apple_market/src/screens/input_screen.dart';
import 'package:apple_market/src/screens/item_detail_screen.dart';
import 'package:apple_market/src/screens/start_screen.dart';
import 'package:apple_market/src/states/category_notifier.dart';
import 'package:apple_market/src/states/select_image_notifier.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore_for_file: constant_identifier_names
const LOCATION_LOGIN = 'login';
const LOCATION_HOME = 'home';
const LOCATION_INPUT = 'input';
const LOCATION_CATEGORY_INPUT = 'category_input';
const LOCATION_ITEM = 'item';
const LOCATION_ITEM_ID = 'item_id';
const LOCATION_CHATROOM_ID = 'chatroom_id';


class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [const BeamPage(key: ValueKey(LOCATION_HOME), child: HomeScreen())];
  }

  @override
  List<Pattern> get pathPatterns => ['/'];

// @override
// // TODO: implement pathPatterns
// List<Pattern> get pathPatterns => ['/'];
}

class InputLocation extends BeamLocation<BeamState> {
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
      ...HomeLocation().buildPages(context, state),
      // 이게 없으면 input 페이지에서 back 버튼이 안생김
      if (state.pathPatternSegments.contains(LOCATION_INPUT))
        // BeamPage(key: const ValueKey('input'), child: const InputScreen()),
        BeamPage(
          key: const ValueKey(LOCATION_INPUT),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: categoryNotifier),
              ChangeNotifierProvider(
                  create: (context) => SelectImageNotifier()),
            ],
            child: const InputScreen(),
          ),
        ),
      if (state.pathPatternSegments.contains(LOCATION_CATEGORY_INPUT))
        // BeamPage(key: const ValueKey('category_input'), child: const CategoryInputScreen()),
        BeamPage(
          key: const ValueKey(LOCATION_CATEGORY_INPUT),
          child: ChangeNotifierProvider.value(
              value: categoryNotifier, child: const CategoryInputScreen()),
        ),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns =>
      ['/$LOCATION_INPUT', '/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT'];
}

class ItemLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [
      ...HomeLocation().buildPages(context, state),
      // 이게 없으면 input 페이지에서 back 버튼이 안생김
      if (state.pathParameters.containsKey(LOCATION_ITEM_ID))
        BeamPage(
          key: const ValueKey(LOCATION_ITEM_ID),
          child: ItemDetailScreen(state.pathParameters[LOCATION_ITEM_ID] ?? ''),
        ),
      if (state.pathParameters.containsKey(LOCATION_CHATROOM_ID))
        BeamPage(
          key: const ValueKey(LOCATION_CHATROOM_ID),
          child: ChatroomScreen(
              chatroomKey: state.pathParameters[LOCATION_CHATROOM_ID] ?? ''),
        ),
    ];
  }

  @override
  // TODO: implement pathBlueprints
  List<Pattern> get pathPatterns =>
      ['/$LOCATION_ITEM/:$LOCATION_ITEM_ID/:$LOCATION_CHATROOM_ID'];
}

class LoginLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [BeamPage(key: const ValueKey(LOCATION_LOGIN), child: StartScreen())];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/login'];
}
