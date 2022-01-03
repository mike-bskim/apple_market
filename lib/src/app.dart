import 'package:apple_market/src/pages/start_page.dart';
import 'package:apple_market/src/router/locations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

final _routerDelegate = BeamerDelegate(
  guards: [BeamGuard(
    pathPatterns: ['/'],
    check: (context, location){return false;},
    showPage: BeamPage(child: StartScreen()),
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
        fontFamily: 'Dohyeon',
        hintColor: Colors.grey[350],
        textTheme: const TextTheme(
          headline3: TextStyle(fontFamily: 'Dohyeon'),
          button: TextStyle(color: Colors.white),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            primary: Colors.white,
            minimumSize: const Size(10,48)
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(color: Colors.black87),
        ),
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}