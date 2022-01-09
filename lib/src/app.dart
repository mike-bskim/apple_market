import 'package:apple_market/src/pages/start_page.dart';
import 'package:apple_market/src/router/locations.dart';
import 'package:apple_market/src/states/user_provider.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(
  guards: [BeamGuard(
    pathPatterns: ['/'],
    check: (context, location){
      return context.watch<UserProvider>().user != null;
    },
    showPage: BeamPage(child: StartScreen()),
  )],
  locationBuilder: BeamerLocationBuilder(beamLocations: [HomeLocation()])
);

class AppleApp extends StatelessWidget {
  const AppleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Dohyeon',
          hintColor: Colors.grey[350],
          textTheme: const TextTheme(
            // headline3: TextStyle(fontFamily: 'Dohyeon'),
            button: TextStyle(color: Colors.white),
            subtitle1: TextStyle(color: Colors.black87, fontSize: 15),
            subtitle2: TextStyle(color: Colors.grey, fontSize: 13),
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
            actionsIconTheme: IconThemeData(color: Colors.black87),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black54,
          ),
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}