import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/constants/shared_pref_key.dart';

// import 'package:apple_market/src/states/user_notifier.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const _duration_300 = Duration(microseconds: 300);
const _duration_1000 = Duration(seconds: 1);

class _AuthPageState extends State<AuthPage> {
  final inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  final TextEditingController _phoneNumberController = TextEditingController(text: "010");

  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;
  String? _verificationId;
  int? _forceResendingToken;

  @override
  Widget build(BuildContext context) {
    logger.d("AuthPage >> build");

    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verificationStatus == VerificationStatus.verifying,
          child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  '전화번호 로그인',
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
                        ExtendedImage.asset(
                          'assets/imgs/padlock.png',
                          width: size.width * 0.15,
                          height: size.width * 0.15,
                        ),
                        const SizedBox(
                          width: padding_08,
                        ),
                        const Text('사과마켓은 휴대폰 번호로 가입해요 \n번호는 안전하게 보관되며 \n어디에도 공개되지 않아요.'),
                      ],
                    ),
                    const SizedBox(
                      height: padding_16,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [MaskedInputFormatter('000 0000 0000')],
                      decoration: InputDecoration(
                        hintText: '전화번호 입력',
                        hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        focusedBorder: inputBorder,
                        border: inputBorder,
                      ),
                      validator: (phoneNumber) {
                        if (phoneNumber != null && phoneNumber.length == 13) {
                          return null;
                        } else {
                          return '전화번호 입력 오류입니다';
                        }
                      },
                    ),
                    const SizedBox(
                      height: padding_16,
                    ),
                    TextButton(
                        onPressed: () async {
                          // _getAddress();
                          FocusScope.of(context).unfocus();
                          if(_verificationStatus == VerificationStatus.codeSending){ return;}
                          if (_formKey.currentState != null) {
                            bool passed = _formKey.currentState!.validate();
                            logger.d('passed >>> ' + passed.toString());
                            if (passed) {
                              var _phoneNum = _phoneNumberController.text;
                              _phoneNum = _phoneNum.replaceAll(' ', '');
                              _phoneNum = _phoneNum.replaceFirst('0', '');
                              _phoneNum = '+82' + _phoneNum;
                              logger.d('_phoneNum: [$_phoneNum]');

                              setState(() {
                                _verificationStatus = VerificationStatus.codeSending;
                              });

                              FirebaseAuth auth = FirebaseAuth.instance;
                              await auth.verifyPhoneNumber(
                                phoneNumber: _phoneNum,
                                forceResendingToken: _forceResendingToken,
                                verificationCompleted: (PhoneAuthCredential credential) async {
                                  // ANDROID ONLY!
                                  // login 이 정상적으로 완료되었는지 확인 코드 추가
                                  logger.d('전화번호 인증 완료 [$credential]');
                                  await auth.signInWithCredential(credential);
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {
                                  // 현재는 아무것도 안한다.
                                },
                                codeSent: (String verificationId, int? forceResendingToken) async {
                                  setState(() {
                                    _verificationStatus = VerificationStatus.codeSent;
                                  });
                                  _verificationId = verificationId;
                                  _forceResendingToken = forceResendingToken;
                                },
                                verificationFailed: (FirebaseAuthException error) {
                                  logger.e(error.message);
                                  setState(() {
                                    _verificationStatus = VerificationStatus.none;
                                  });
                                },
                              );
                            } else {
                              setState(() {
                                _verificationStatus = VerificationStatus.none;
                              });
                            }
                          }
                        },
                        child: _verificationStatus == VerificationStatus.codeSending
                            ? const SizedBox(
                                height: 26,
                                width: 26,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text('인증문자 발송')),
                    const SizedBox(
                      height: padding_16 * 2,
                    ),
                    AnimatedOpacity(
                      duration: _duration_300,
                      opacity: (_verificationStatus == VerificationStatus.none) ? 0 : 1,
                      child: AnimatedContainer(
                        duration: _duration_1000,
                        curve: Curves.easeInOut,
                        height: getVerificationHeight(_verificationStatus),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [MaskedInputFormatter('000000')],
                          decoration: InputDecoration(
                            // hintText: '인증문자 입력',
                            hintStyle: TextStyle(color: Theme.of(context).hintColor),
                            focusedBorder: inputBorder,
                            border: inputBorder,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: padding_16,
                    ),
                    AnimatedContainer(
                      duration: _duration_1000,
                      height: getVerificationBtnHeight(_verificationStatus),
                      child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            attemptVarify(context);
                          },
                          child: _verificationStatus == VerificationStatus.verifying
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('인증')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double? getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60;
    }
  }

  double? getVerificationBtnHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48;
    }
  }

  void attemptVarify(BuildContext context) async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _codeController.text);
      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      logger.e('verification failed !!!');
      SnackBar _snackBar = const SnackBar(content: Text('입력하신 코드 오류입니다'));
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }
    // Create a PhoneAuthCredential with the code

    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });

    // context.read<UserProvider>().setUserAuth(true);
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString(SHARED_ADDRESS) ?? '';
    double lat = prefs.getDouble(SHARED_LAT) ?? 0;
    double lon = prefs.getDouble(SHARED_LON) ?? 0;
    logger.d('get Address: [$address] [$lat] [$lon]');
  }

}

enum VerificationStatus { none, codeSending, codeSent, verifying, verificationDone }
