import 'package:apple_market/src/screens/home_screen.dart';
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
      ...HomeLocation().buildPages(context, state),
      if (state.pathPatternSegments.contains('input'))
        const BeamPage(key: ValueKey('input'), child: InputScreen()),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/input'];
}
