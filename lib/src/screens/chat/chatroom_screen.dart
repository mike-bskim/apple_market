import 'package:apple_market/src/model/chat_model.dart';
import 'package:apple_market/src/model/chatroom_model.dart';
import 'package:apple_market/src/model/user_model.dart';
import 'package:apple_market/src/repo/chat_service.dart';
import 'package:apple_market/src/screens/chat/chat.dart';
import 'package:apple_market/src/states/chat_notifier.dart';
import 'package:apple_market/src/states/user_notifier.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatroomKey;

  const ChatroomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  late String newChatroomKey;
  final TextEditingController _textEditingController = TextEditingController();
  late ChatNotifier _chatNotifier;

  @override
  void initState() {
    // TODO: implement initState
    newChatroomKey = widget.chatroomKey;
    if (widget.chatroomKey[0] == ':') {
      newChatroomKey = widget.chatroomKey.substring(1);
    }
    logger.d({
      'chatroomKey': '[${widget.chatroomKey}]',
      'newChatroomKey': '[$newChatroomKey]'
    });
    _chatNotifier = ChatNotifier(newChatroomKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatNotifier>.value(
      value: _chatNotifier,
      child: Consumer<ChatNotifier>(
        builder: (context, chatNotifier, child) {
          Size _size = MediaQuery.of(context).size;
          UserModel userModel = context.read<UserNotifier>().userModel!;
          return Scaffold(
            appBar: AppBar(),
            backgroundColor: Colors.grey[200],
            body: SafeArea(
              child: Column(
                children: [
                  _buildItemInfo(context),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: ListView.separated(
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          bool _isMine = chatNotifier.chatList[index].userKey ==
                              userModel.userKey;
                          return Chat(
                            size: _size,
                            isMine: _isMine,
                            chatModel: chatNotifier.chatList[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                        itemCount: chatNotifier.chatList.length,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(4)),
                  _buildInputBar(userModel)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  MaterialBanner _buildItemInfo(BuildContext context) {
    ChatroomModel? chatroomModel = context.read<ChatNotifier>().chatroomModel;
    return MaterialBanner(
      padding: EdgeInsets.zero,
      leadingPadding: EdgeInsets.zero,
      actions: [Container()],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 12, top: 12, bottom: 12),
                child: chatroomModel == null
                    ? Shimmer.fromColors(
                        highlightColor: Colors.grey[200]!,
                        baseColor: Colors.grey,
                        child: Container(
                          width: 48,
                          height: 48,
                          color: Colors.white,
                        ),
                      )
                    : ExtendedImage.network(
                        chatroomModel.itemImage,
                        // 'https://randomuser.me/api/portraits/lego/4.jpg', // lego pic
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: '거래완료',
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                              text: chatroomModel == null
                                  ? ''
                                  : ' ' + chatroomModel.itemTitle,
                              style: Theme.of(context).textTheme.bodyText2)
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        text: chatroomModel == null
                            ? ''
                            : chatroomModel.itemPrice.toCurrencyString(
                                mantissaLength: 0, trailingSymbol: '원'),
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                              text: ' (가격제한불가)',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.black26))
                        ]),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: SizedBox(
              height: 32,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.black87,
                ),
                label: Text(
                  '후기 남기기',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black87),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(UserModel userModel) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                suffixIcon: GestureDetector(
                  onTap: () {
                    logger.d('Icon clicked');
                  },
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.grey,
                  ),
                ),
                suffixIconConstraints: BoxConstraints.tight(const Size(40, 40)),
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              ChatModel chatModel = ChatModel(
                userKey: userModel.userKey,
                msg: _textEditingController.text,
                createDate: DateTime.now(),
              );

              // await ChatService().createNewChat(newChatroomKey, chatModel);
              _chatNotifier.addNewChat(chatModel);
              logger.d(_textEditingController.text.toString());
              _textEditingController.clear();
            },
            icon: const Icon(
              Icons.send,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
