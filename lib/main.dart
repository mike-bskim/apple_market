import 'package:apple_market/src/app.dart';
import 'package:apple_market/src/screens/splash_screen.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  logger.d('Starting MyApp()');
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); 이것을 app.dart 로 이동.
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _initialization, //Future.delayed(const Duration(seconds: 2), ()=>100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _splashLoadingWidget(snapshot));
      }
    );
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object> snapshot) {
    if(snapshot.hasError) {
      logger.d('error occur while loading ~');
      return const Text('Error ocure');
    } else if (snapshot.connectionState == ConnectionState.done) {
      return const AppleApp();
    } else {
      return const SplashScreen();
    }
  }
}



