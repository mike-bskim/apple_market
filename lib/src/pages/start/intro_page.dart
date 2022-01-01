import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final PageController controller;
  const IntroPage(this.controller, {Key? key}) : super(key: key);

  void onButtonClick(){
    controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    logger.d('on Text Button Clicked !!!');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        Size size = MediaQuery.of(context).size;

        final imgSize = size.width - 32;
        final sizeOfPosImg = imgSize * 0.1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Apple Market',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                  // style: TextStyle(
                  //   fontSize: 30,
                  //   color: Theme.of(context).colorScheme.primary,
                  //   fontWeight: FontWeight.bold,
                  //   ),
                ),
                SizedBox(
                  width: imgSize,
                  height: imgSize,
                  child: Stack(
                    children: <Widget>[
                      ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                      Positioned(
                          width: sizeOfPosImg,
                          height: sizeOfPosImg,
                          left: imgSize * 0.45,
                          top: imgSize * 0.45,
                          child: ExtendedImage.asset('assets/imgs/carrot_intro_pos.png')
                      ),
                    ],
                  ),
                ),
                const Text('우리 동네 중고 직거래 사과마켓',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '사과 마켓은 동네 직거래 마켓이에요\n'
                      '내 동네를 설정하고 시작해보세요',
                  style: TextStyle(fontSize: 16,),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextButton(
                        onPressed: onButtonClick,
                        child: Text('내 동네 설정하고 시작하기',
                          style: Theme.of(context).textTheme.button,
                        ),
                        style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
