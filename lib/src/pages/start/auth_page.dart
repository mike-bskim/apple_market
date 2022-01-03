import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  final inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  final TextEditingController _phoneNumberController = TextEditingController(); // text: "010"
  final TextEditingController _codeController = TextEditingController(); // text: "010"

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {

        Size size = MediaQuery.of(context).size;

        return Form(
          key: _formKey,
          child: Scaffold(
            appBar: AppBar(
              title: Text('전화번호 로그인',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(padding_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ExtendedImage.asset('assets/imgs/padlock.png',
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                      ),
                      const SizedBox(width: padding_08,),
                      const Text('사과마켓은 휴대폰 번호로 가입해요 \n번호는 안전하게 보관되며 \n어디에도 공개되지 않아요.'),
                    ],
                  ),
                  const SizedBox(height: padding_16,),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [MaskedInputFormatter('000 0000 0000')],
                    decoration: InputDecoration(
                      hintText: '전화번호 입력',
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      focusedBorder:inputBorder,
                      border:inputBorder,
                    ),
                    validator: (phoneNumber){
                      if (phoneNumber != null && phoneNumber.length == 13) {
                        return null;
                      } else {
                        return '전화번호 입력 오류입니다';
                     }
                    },
                  ),
                  const SizedBox(height: padding_16,),
                  TextButton(
                    onPressed: (){
                      if (_formKey.currentState != null) {
                        bool passed = _formKey.currentState!.validate();
                        logger.d('passed >>> ' + passed.toString());
                      }

                    },
                    child: const Text('인증문자 발송')
                  ),
                  const SizedBox(height: padding_16 * 2,),
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [MaskedInputFormatter('000000')],
                    decoration: InputDecoration(
                      hintText: '인증문자 입력',
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      focusedBorder:inputBorder,
                      border:inputBorder,
                    ),
                  ),
                  const SizedBox(height: padding_16,),
                  TextButton(onPressed: (){}, child: const Text('인증')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
