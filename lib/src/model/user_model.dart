import 'package:apple_market/src/constants/data_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  late num lat;
  late num lon;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;

  UserModel({
    required this.userKey,
    required this.phoneNumber,
    required this.address,
    required this.lat,
    required this.lon,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,
  });

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
    userKey = json[DOC_USERKEY];
    phoneNumber = json[DOC_PHONENUMBER];
    address = json[DOC_ADDRESS];
    lat = json[DOC_LAT];
    lon = json[DOC_LON];
    geoFirePoint = GeoFirePoint(
        (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude, (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude);
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(
          snapshot.data()!,
          snapshot.id,
          snapshot.reference,
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_PHONENUMBER] = phoneNumber;
    map[DOC_ADDRESS] = address;
    map[DOC_LAT] = lat;
    map[DOC_LON] = lon;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_CREATEDDATE] = createdDate;
    // map['reference'] = reference;
    return map;
  }
}
