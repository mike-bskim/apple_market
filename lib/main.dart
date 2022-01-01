import 'dart:developer';

import 'package:apple_market/src/app.dart';
import 'package:apple_market/src/pages/splash_page.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:flutter/material.dart';

void main() {
  logger.d('Starting MyApp()');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: Future.delayed(const Duration(seconds: 2), ()=>100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _splashLoadingWidget(snapshot));
      }
    );
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object> snapshot) {
    if(snapshot.hasError) {
      log('error occur while loading ~');
      return const Text('Error ocure');
    } else if (snapshot.hasData) {
      return const AppleApp();
    } else {
      return const SplashScreen();
    }
  }
}



