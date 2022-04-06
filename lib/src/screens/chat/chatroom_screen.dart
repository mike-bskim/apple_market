import 'package:apple_market/src/model/chat_model.dart';
import 'package:apple_market/src/model/user_model.dart';
import 'package:apple_market/src/repo/chat_service.dart';
import 'package:apple_market/src/screens/chat/chat.dart';
import 'package:apple_market/src/states/user_notifier.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatroomKey;

  const ChatroomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  late String newChatroomKey;
  final TextEditingController _textEditingController = TextEditingController();

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;
        UserModel userModel = context.read<UserNotifier>().userModel!;
        return Scaffold(
          appBar: AppBar(),
          backgroundColor: Colors.grey[200],
          body: SafeArea(
            child: Column(
              children: [
                MaterialBanner(
                  padding: EdgeInsets.zero,
                  leadingPadding: EdgeInsets.zero,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        dense: true,
                        minVerticalPadding: 0,
                        contentPadding:
                            const EdgeInsets.only(left: 4, right: 0),
                        leading: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, top: 8, bottom: 4),
                          child: ExtendedImage.network(
                            'https://randomuser.me/api/portraits/lego/4.jpg',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: RichText(
                          text: TextSpan(
                              text: '거래완료',
                              style: Theme.of(context).textTheme.bodyText1,
                              children: [
                                TextSpan(
                                    text: ' 이케아 소르테라 분리수거함 ',
                                    style:
                                        Theme.of(context).textTheme.bodyText2)
                              ]),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                              text: '30,000원',
                              style: Theme.of(context).textTheme.bodyText1,
                              children: [
                                TextSpan(
                                    text: ' (가격제한불가)',
                                    style:
                                        Theme.of(context).textTheme.bodyText2!
                                          ..copyWith(color: Colors.black26))
                              ]),
                        ),
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
                              style: Theme.of(context).textTheme.bodyText1!
                                ..copyWith(color: Colors.black87),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(
                                    color: Colors.grey[300]!, width: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [Container()],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        bool _isMine = (index % 2) == 0;
                        return Chat(size: _size, isMine: _isMine);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 12,
                        );
                      },
                      itemCount: 30,
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
              print('chatroomKey:  ' + widget.chatroomKey.toString());
              print('newChatroomKey:' + newChatroomKey.toString());

              ChatModel chatModel = ChatModel(
                userKey: userModel.userKey,
                createDate: DateTime.now(),
                msg: _textEditingController.text,
              );
              await ChatService().createNewChat(newChatroomKey, chatModel);
              print(_textEditingController.text.toString());
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
