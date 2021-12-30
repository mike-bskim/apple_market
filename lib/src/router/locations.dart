import 'package:apple_market/src/pages/home_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    // TODO: implement buildPages
    return [const BeamPage(child: HomeScreen(), key: ValueKey('home'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/'];
  
}

