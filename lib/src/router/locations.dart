import 'package:apple_market/src/pages/home_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    // TODO: implement buildPages
    return [const BeamPage(child: HomeScreen(), key: ValueKey('home'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/'];
}

class InputLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState  state) {
    // TODO: implement buildPages
    return [
      ...HomeLocation().buildPages(context, state),
      if(state.pathPatternSegments.contains('input'))
        BeamPage(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Input Page'),
            ),
            body: Container(
              color: Colors.amber,
            ),
          ),
          key: const ValueKey('input'),
        ),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/input'];
}
