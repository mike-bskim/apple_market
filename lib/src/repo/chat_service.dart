import 'dart:async';

import 'package:apple_market/src/constants/data_keys.dart';
import 'package:apple_market/src/model/chat_model.dart';
import 'package:apple_market/src/model/chatroom_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();

  factory ChatService() => _chatService;

  ChatService._internal();

  Future createNewChatroom(ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(ChatroomModel.generateChatRoomKey(
            chatroomModel.buyerKey, chatroomModel.itemKey));

    final DocumentSnapshot documentSnapshot = await docRef.get();

    if (!documentSnapshot.exists) {
      await docRef.set(chatroomModel.toJson());
    }
  }

  Future createNewChat(String chatroomKey, ChatModel chatModel) async {
    DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .doc();

    DocumentReference<Map<String, dynamic>> chatroomDocRef =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    await docRef.set(chatModel.toJson());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(docRef, chatModel.toJson());
      transaction.update(chatroomDocRef, {
        DOC_LASTMSG: chatModel.msg,
        DOC_LASTMSGTIME: chatModel.createDate,
        DOC_LASTMSGUSERKEY: chatModel.userKey
      });
    });
  }

//todo: get chatroom detail

  Stream<ChatroomModel> connectChatroom(String chatroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .snapshots()
        .transform(snapshotToChatroom);
  }

  var snapshotToChatroom = StreamTransformer<
      DocumentSnapshot<Map<String, dynamic>>,
      ChatroomModel>.fromHandlers(handleData: (snapshot, sink) {
    ChatroomModel chatroom = ChatroomModel.fromSnapshot(snapshot);
    sink.add(chatroom);
  });

//todo: get char list
  Future<List<ChatModel>> getChatList(String chatroomKey) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(10)
        .get();

    List<ChatModel> chatlist = [];

    for (var docSnapshot in snapshot.docs) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    }
    return chatlist;
  }

//todo: latest chats
  Future<List<ChatModel>> getLatestChats(
      String chatroomKey, DocumentReference currentLastestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection(COL_CHATROOMS)
            .doc(chatroomKey)
            .collection(COL_CHATS)
            .orderBy(DOC_CREATEDDATE, descending: true)
            // .endAtDocument(await currentLastestChatRef.get())
            .endBeforeDocument(await currentLastestChatRef.get())
            .get();

    List<ChatModel> chatlist = [];

    for (var docSnapshot in snapshot.docs) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    }
    return chatlist;
  }

//todo: older chats
  Future<List<ChatModel>> getOlderChats(
      String chatroomKey, DocumentReference oldestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .startAfterDocument(await oldestChatRef.get())
        .limit(10)
        .get();

    List<ChatModel> chatlist = [];

    for (var docSnapshot in snapshot.docs) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    }
    return chatlist;
  }

  Future<List<ChatroomModel>> getMyChatList(String myUserKey) async {
    List<ChatroomModel> chatrooms = [];

    // todo: I am as a buyer
    QuerySnapshot<Map<String, dynamic>> buying = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_BUYERKEY, isEqualTo: myUserKey)
        .get();

    // todo: I am as a seller
    QuerySnapshot<Map<String, dynamic>> selling = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_SELLERKEY, isEqualTo: myUserKey)
        .get();

    for (var documentSnapshot in buying.docs) {
      chatrooms.add(ChatroomModel.fromQuerySnapshot(documentSnapshot));
    }
    for (var documentSnapshot in selling.docs) {
      chatrooms.add(ChatroomModel.fromQuerySnapshot(documentSnapshot));
    }

    chatrooms.sort((a, b) => (a.lastMsgTime).compareTo(b.lastMsgTime));

    return chatrooms;
  }
}
