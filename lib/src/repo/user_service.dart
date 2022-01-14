import 'package:apple_market/src/constants/data_keys.dart';
import 'package:apple_market/src/model/user_model.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();

  Future createNewUser(Map<String, dynamic> json, String userKey) async {

    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot documentSnapshot = await docRef.get();

    if(!documentSnapshot.exists){
      await docRef.set(json);
    }
  }

  Future<UserModel> getUserModel(String userKey) async {

    DocumentReference<Map<String, dynamic>> docRef =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await docRef.get();

    // var temp = documentSnapshot.data();
    // print('documentSnapshot: ${temp!['address']}');
    // print('documentSnapshot: ${documentSnapshot['address']}');
    // print('documentSnapshot: ${temp['createdDate']}');
    // print('documentSnapshot: ${documentSnapshot.id}');
    // print('documentSnapshot: ${documentSnapshot.reference}');

    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    // logger.d('--------------------------------------------------');
    // logger.d(userModel.geoFirePoint.latitude, userModel.geoFirePoint.longitude);

    return userModel;
  }

  Future fireStoreTest() async {
    FirebaseFirestore.instance.collection('TestCollection').add({
      'testing': 'testing value',
      'number': 123,
    });
  }

  void fireStoreReadTest() {
    FirebaseFirestore.instance
        .collection('TestCollection')
        .doc('RwV1JzhS1lhoKZ1dcq90')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) {
      logger.d(value.data());
    });
  }
}
