import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset('assets/imgs/apple.png'),
            ExtendedImage.asset('assets/imgs/apple.png'),
            const SizedBox(height: 100.0,),
            const CircularProgressIndicator(color: Colors.red,)
            // Container(height: 100, color: Colors.blueAccent,),
          ],
        )
      ),
    );
  }
}