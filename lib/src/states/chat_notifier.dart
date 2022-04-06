import 'package:apple_market/src/model/chat_model.dart';
import 'package:apple_market/src/model/chatroom_model.dart';
import 'package:apple_market/src/repo/chat_service.dart';
import 'package:apple_market/src/utils/logger.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatNotifier extends ChangeNotifier {
  late ChatroomModel _chatroomModel;
  final List<ChatModel> _chatList = [];
  late String _chatroomKey;

  ChatNotifier(this._chatroomKey) {
    // todo: connect chatroom
    ChatService().connectChatroom(_chatroomKey).listen((chatroomModel) {
      _chatroomModel = chatroomModel;

      if (_chatList.isEmpty) {
        // todo: fetch 10 latest chats, if chat list is empty
        ChatService().getChatList(_chatroomKey).then((chatList) {
          _chatList.addAll(chatList);
          // _chatList.addAll(chatList.reversed);
          notifyListeners();
        });
      } else {
        // todo: when new chatroom arrive, fetch latest chats
        if (_chatList[0].reference == null) {
          _chatList.removeAt(0);
        }
        ChatService()
            .getLatestChats(_chatroomKey, _chatList[0].reference!)
            .then((latestChats) {
          _chatList.insertAll(0, latestChats);
          // _chatList.addAll(latestChats.reversed);
          notifyListeners();
        });
      }
    });
  }

  void addNewChat(ChatModel chatModel) {
    logger.d('chatroomKey>>>' + chatroomKey.toString());

    _chatList.insert(0, chatModel);
    notifyListeners();

    ChatService().createNewChat(_chatroomKey, chatModel);
    // ChatService().createNewChat(chatroomKey, chatModel);
  }

  List<ChatModel> get chatList => _chatList;

  ChatroomModel get chatroomModel => _chatroomModel;

  String get chatroomKey => _chatroomKey;
}
