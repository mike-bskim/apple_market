import 'package:apple_market/src/model/chat_model.dart';
import 'package:apple_market/src/model/chatroom_model.dart';
import 'package:apple_market/src/repo/chat_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatNotifier extends ChangeNotifier {
  late ChatroomModel _chatroomModel;
  final List<ChatModel> _chatList = [];
  late String _chatroomKey;

  ChatNotifier(_chatroomKey) {
    // todo: connect chatroom
    ChatService().connectChatroom(_chatroomKey).listen((chatroomModel) {
      _chatroomModel = chatroomModel;

      if (_chatList.isEmpty) {
        // todo: fetch 10 latest chats, if chat list is empty
        ChatService().getChatList(_chatroomKey).then((chatList) {
          _chatList.addAll(chatList);
          notifyListeners();
        });
      } else {
        // todo: when new chatroom arrive, fetch latest chats
        ChatService().getLatestChats(_chatroomKey, _chatList[0].reference!).then((latestChats) {
          _chatList.insertAll(0, latestChats);
          notifyListeners();
        });
      }
    });
  }
}
