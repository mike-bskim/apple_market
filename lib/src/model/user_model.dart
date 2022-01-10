import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  late num lat;
  late num lon;
  late GerFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;
}