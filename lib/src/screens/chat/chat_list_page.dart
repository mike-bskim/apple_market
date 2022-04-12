import 'package:apple_market/src/model/chatroom_model.dart';
import 'package:apple_market/src/repo/chat_service.dart';
// import 'package:apple_market/src/states/user_notifier.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
// import 'package:provider/src/provider.dart';

class ChatListPage extends StatelessWidget {
  final String userKey;
  const ChatListPage({Key? key, required this.userKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String userKey = context.read<UserNotifier>().userModel!.userKey;


    return FutureBuilder<List<ChatroomModel>>(
        future: ChatService().getMyChatList(userKey),
        builder: (context, snapshot) {
          Size _size = MediaQuery.of(context).size;

          return Scaffold(
            body: ListView.separated(
                itemBuilder: (context, index) {
                  ChatroomModel chatroomModel = snapshot.data![index];
                  // bool iamBuyer = chatroomModel.buyerKey == userKey;

                  List _address = chatroomModel.itemAddress.split(' ');
                  String _detail = _address[_address.length - 1];
                  String _location = '';
                  if (_detail.contains('(') && _detail.contains(')')) {
                    _location = _detail.replaceAll('(', '').replaceAll(')', '');
                  } else {
                    _location = _address[2];
                  }

                  return ListTile(
                    onTap: (){
                      logger.d(chatroomModel.chatroomKey);
                      context.beamToNamed('/${chatroomModel.chatroomKey}');
                    },
                    leading: ExtendedImage.network(
                      'https://randomuser.me/api/portraits/women/18.jpg',
                      height: _size.height / 8,
                      width: _size.width / 8,
                      fit: BoxFit.cover,
                      shape: BoxShape.circle,
                    ),
                    trailing: ExtendedImage.network(
                      chatroomModel.itemImage,
                      height: _size.height / 8,
                      width: _size.width / 8,
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // title: RichText(
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   text: TextSpan(
                    //     text: iamBuyer?chatroomModel.sellerKey:chatroomModel.buyerKey,
                    //     style: Theme.of(context).textTheme.subtitle1,
                    //     children: [
                    //       TextSpan(text: ' '),
                    //       TextSpan(
                    //         text: chatroomModel.itemAddress,
                    //         style: Theme.of(context).textTheme.subtitle2,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chatroomModel.itemTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Text(
                          _location=='+'? _address[0] : _location, //chatroomModel.itemAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      chatroomModel.lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                      thickness: 1, height: 1, color: Colors.grey[300]);
                },
                itemCount: snapshot.hasData ? snapshot.data!.length : 0),
          );
        });
  }
}
