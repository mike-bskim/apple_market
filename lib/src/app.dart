import 'package:apple_market/src/screens/start_screen.dart';
import 'package:apple_market/src/router/locations.dart';
import 'package:apple_market/src/states/user_notifier.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
        pathPatterns: [
          // pathBlueprints: [
          ...HomeLocation().pathPatterns,
          ...InputLocation().pathPatterns,
          ...ItemLocation().pathPatterns,
        ],
        check: (context, location) {
          return context.watch<UserNotifier>().user != null;
        },
        showPage: BeamPage(child: StartScreen()),
      )
    ],
    locationBuilder:
        BeamerLocationBuilder(beamLocations: [HomeLocation(), InputLocation(), ItemLocation()]));

class AppleApp extends StatelessWidget {
  const AppleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserNotifier>(
      create: (BuildContext context) {
        return UserNotifier();
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
            // bodyText1: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w400),
            bodyText2: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w100),

          ),
          // inputDecorationTheme: const InputDecorationTheme(
          //   enabledBorder: UnderlineInputBorder(
          //     borderSide: BorderSide(color: Colors.transparent),
          //   ),
          // ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                primary: Colors.white,
                minimumSize: const Size(10, 48)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
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
