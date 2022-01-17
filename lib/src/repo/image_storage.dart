import 'dart:typed_data';
import 'package:apple_market/src/utils/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorage {

  static Future<List<String>> uploadImage(List<Uint8List> images, String itemKey) async {

    var metaData = SettableMetadata(contentType: 'image/jpeg');
    List<String> downloadUrls = [];

    for (var i = 0; i < images.length; i++) {
      Reference ref =
      FirebaseStorage.instance.ref('images/$itemKey/$i.jpg');
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
