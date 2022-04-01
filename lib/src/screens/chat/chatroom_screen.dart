import 'package:apple_market/src/utils/logger.dart';
import 'package:flutter/material.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatroomKey;

  const ChatroomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  late String newChatroomKey;

  @override
  void initState() {
    // TODO: implement initState
    newChatroomKey = widget.chatroomKey.substring(0);
    if (widget.chatroomKey[0] == ':') {
      newChatroomKey = widget.chatroomKey.substring(1);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.yellowAccent,
              ),
            ),
            // const Padding(padding: EdgeInsets.all(4)),
            Row(
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
                    suffixIconConstraints: BoxConstraints.tight(Size(40, 40)),
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                )),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                    color: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
