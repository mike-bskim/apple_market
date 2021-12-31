import 'package:apple_market/src/pages/auth_page.dart';
import 'package:apple_market/src/router/locations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

final _routerDelegate = BeamerDelegate(
  guards: [BeamGuard(
    pathPatterns: ['/'],
    check: (context, location){return false;},
    showPage: const BeamPage(child: AuthScreen()),
  )],
  locationBuilder: BeamerLocationBuilder(beamLocations: [HomeLocation()])
);

class AppleApp extends StatelessWidget {
  const AppleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.red,
        // fontFamily: 'Dohyeon',
        textTheme: const TextTheme(
          headline3: TextStyle(fontFamily: 'Dohyeon'),
          button: TextStyle(color: Colors.white),
        )
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}