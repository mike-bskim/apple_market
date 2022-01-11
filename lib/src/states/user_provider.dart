import 'package:apple_market/src/constants/shared_pref_key.dart';
import 'package:apple_market/src/model/user_model.dart';
import 'package:apple_market/src/repo/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {

  UserProvider() {
    initUser();
  }

  User? _user;
  UserModel? _userModel;

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      // _user = user;
      // logger.d('user status: [$_user]');
      await _setNewUser(user);
      notifyListeners();
    });
  }

  Future<void> _setNewUser(User? user) async {
    _user = user;

    if (user != null && user.phoneNumber != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String address = prefs.getString(SHARED_ADDRESS) ?? '';
      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String phoneNumber = user.phoneNumber!;
      String userKey = user.uid;

      UserModel userModel = UserModel(
        userKey: userKey,
        phoneNumber: phoneNumber,
        address: address,
        // lat: lat,
        // lon: lon,
        geoFirePoint: GeoFirePoint(lat, lon),
        createdDate: DateTime.now().toUtc(),
      );

      await UserService().createNewUser(userModel.toJson(), userKey);
      _userModel = await UserService().getUserModel(userKey);

    }
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