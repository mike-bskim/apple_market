import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ItemModel {
  late String itemKey;
  late String userKey;
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
    // itemKey = json['itemKey'] ?? '';
    userKey = json['userKey'] ?? '';
    imageDownloadUrls =
        json['imageDownloadUrls'] != null ? json['imageDownloadUrls'].cast<String>() : [];
    title = json['title'] ?? '';
    category = json['category'] ?? '';
    price = json['price'] ?? 0;
    negotiable = json['negotiable'] ?? false;
    detail = json['detail'] ?? '';
    address = json['address'] ?? '';
    geoFirePoint = GeoFirePoint(
        (json['geoFirePoint']['geopoint']).latitude, (json['geoFirePoint']['geopoint']).longitude);
    createdDate = json['createdDate'] == null
        ? DateTime.now().toUtc()
        : (json['createdDate'] as Timestamp).toDate();
    // reference = json['reference'];
  }

  ItemModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['itemKey'] = itemKey;
    map['userKey'] = userKey;
    map['imageDownloadUrls'] = imageDownloadUrls;
    map['title'] = title;
    map['category'] = category;
    map['price'] = price;
    map['negotiable'] = negotiable;
    map['detail'] = detail;
    map['address'] = address;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createdDate'] = createdDate;
    // map['reference'] = reference;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    final map = <String, dynamic>{};
    map['imageDownloadUrls'] = imageDownloadUrls.sublist(0, 1);
    map['title'] = title;
    map['price'] = price;
    return map;
  }

  static String generateItemKey(String uid) {
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();

    return '${uid}_$timeInMilli';
  }
}
