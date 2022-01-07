import 'package:apple_market/src/pages/home/items_page.dart';
import 'package:apple_market/src/states/user_provider.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    logger.d('HomeScreen >> build');
    logger.d('current user state: ${context.read<UserProvider>().userState}');

    return Scaffold(

      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '세종대로',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<UserProvider>().setUserAuth(false);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                context.read<UserProvider>().setUserAuth(false);
              },
              icon: const Icon(CupertinoIcons.search)),
          IconButton(
              onPressed: () {
                context.read<UserProvider>().setUserAuth(false);
              },
              icon: const Icon(CupertinoIcons.text_justify)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
          });
        },
        currentIndex: _bottomSelectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 0
                ? 'assets/imgs/house_filled.png'
                : 'assets/imgs/house.png')),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 1
                ? 'assets/imgs/near-me_filled.png'
                : 'assets/imgs/near-me.png')),
            label: 'near',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 2
                ? 'assets/imgs/chat_filled.png'
                : 'assets/imgs/chat.png')),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 3
                ? 'assets/imgs/user_filled.png'
                : 'assets/imgs/user.png')),
            label: 'me',
          ),
        ],
      ),
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: <Widget>[
          ItemsPage(),
          Container(color: Colors.accents[1],),
          Container(color: Colors.accents[2],),
          Container(color: Colors.accents[3],),
        ],
      )
    );
  }
}
