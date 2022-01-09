import 'package:apple_market/src/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier{

  UserProvider(){
    initUser();
  }

  User? _user;
  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      logger.d('user status: [$_user]');
      notifyListeners();
    });
  }

  User? get user => _user;

  // 전화인증을 구현 이전, 테스트용 코드
  // bool _userLoggedIn = false;
  // void setUserAuth(bool authState){
  //   _userLoggedIn = authState;
  //   notifyListeners();
  // }
  // bool get userState => _userLoggedIn;
}