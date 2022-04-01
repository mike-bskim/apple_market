import 'package:apple_market/src/constants/data_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// chatKey : "",
/// msg : "",
/// createDate : "",
/// userKey : "",
/// reference : ""

class ChatModel {
  late String chatKey;
  late String msg;
  late String createDate;
  late String userKey;
  DocumentReference? reference;

  ChatModel({
    required this.chatKey,
    required this.msg,
    required this.createDate,
    required this.userKey,
    this.reference,
  });

  ChatModel.fromJson(Map<String, dynamic> json, this.chatKey, this.reference) {
    chatKey = json[DOC_CHATKEY];
    msg = json[DOC_MSG];
    createDate = json[DOC_CREATEDDATE];
    userKey = json[DOC_USERKEY];
    // reference = json['reference'];
  }

  ChatModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_CHATKEY] = chatKey;
    map[DOC_MSG] = msg;
    map[DOC_CREATEDDATE] = createDate;
    map[DOC_USERKEY] = userKey;
    // map['reference'] = reference;
    return map;
  }
}
