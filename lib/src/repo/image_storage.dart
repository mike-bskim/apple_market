import 'dart:typed_data';
import 'package:apple_market/src/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorage {

  static Future<List<String>> uploadImage(List<Uint8List> images) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return [];
    }
    String userKey = FirebaseAuth.instance.currentUser!.uid;
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();

    var metaData = SettableMetadata(contentType: 'image/jpeg');
    List<String> downloadUrls = [];
    // =
    // logger.d('_link:[$_link]');

    for (var i = 0; i < images.length; i++) {
      Reference ref =
      FirebaseStorage.instance.ref('images/${userKey}_$timeInMilli/$i.jpg');
      if (images.isNotEmpty) {
        await ref.putData(images[i], metaData).catchError((onError){
          logger.e('picture uploading error: ' + onError.toString());
        });
        downloadUrls.add(await ref.getDownloadURL());
      }
    }

    return downloadUrls;
  }
}
