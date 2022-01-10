import 'package:apple_market/src/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future firestoreTest() async {
    FirebaseFirestore.instance
      .collection('TestCollection')
      .add({
        'testing': 'testing value',
        'number':123,
    });
  }

  void firestoreReadTest() {

    FirebaseFirestore.instance
      .collection('TestCollection')
      .doc('RwV1JzhS1lhoKZ1dcq90')
      .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) {
          logger.d(value.data());
    });
  }
}
