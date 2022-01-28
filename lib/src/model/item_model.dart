import 'package:apple_market/src/constants/data_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ItemModel {
  late String itemKey;
  late String userKey;
  late String userPhone;
  late List<String> imageDownloadUrls;
  late String title;
  late String category;
  late num price;
  late bool negotiable;
  late String detail;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;

  ItemModel({
    required this.itemKey,
    required this.userKey,
    required this.userPhone,
    required this.imageDownloadUrls,
    required this.title,
    required this.category,
    required this.price,
    required this.negotiable,
    required this.detail,
    required this.address,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,
  });

  ItemModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
    // itemKey = json[DOC_ITEMKEY] ?? '';
    userKey = json[DOC_USERKEY] ?? '';
    userPhone = json[DOC_USERPHONE] ?? '';
    imageDownloadUrls =
        json[DOC_IMAGEDOWNLOADURLS] != null ? json[DOC_IMAGEDOWNLOADURLS].cast<String>() : [];
    title = json[DOC_TITLE] ?? '';
    category = json[DOC_CATEGORY] ?? '';
    price = json[DOC_PRICE] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    detail = json[DOC_DETAIL] ?? '';
    address = json[DOC_ADDRESS] ?? '';
    geoFirePoint = json[DOC_GEOFIREPOINT] == null
        ? GeoFirePoint(0, 0)
        : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
            (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude);
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
    // reference = json['reference'];
  }

  ItemModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_ITEMKEY] = itemKey;
    map[DOC_USERKEY] = userKey;
    map[DOC_USERPHONE] = userPhone;
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls;
    map[DOC_TITLE] = title;
    map[DOC_CATEGORY] = category;
    map[DOC_PRICE] = price;
    map[DOC_NEGOTIABLE] = negotiable;
    map[DOC_DETAIL] = detail;
    map[DOC_ADDRESS] = address;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_CREATEDDATE] = createdDate;
    // map['reference'] = reference;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    final map = <String, dynamic>{};
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls.sublist(0, 1);
    map[DOC_TITLE] = title;
    map[DOC_PRICE] = price;
    return map;
  }

  static String generateItemKey(String uid) {
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();

    return '${uid}_$timeInMilli';
  }
}
