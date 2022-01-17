import 'package:apple_market/src/router/locations.dart';
import 'package:apple_market/src/screens/home/items_page.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:apple_market/src/widgets/expandable_fab.dart';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(

      floatingActionButton: ExpandableFab(
        distance: 90,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              context.beamToNamed('/$LOCATION_INPUT');
            },
            shape: const CircleBorder(),
            height: 48,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.edit),
          ),
          MaterialButton(
            onPressed: () {},
            shape: const CircleBorder(),
            height: 48,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.input),
          ),
          MaterialButton(
            onPressed: () {},
            shape: const CircleBorder(),
            height: 48,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          ),
        ],

      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '세종대로',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.search)),
          IconButton(
              onPressed: () {},
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
          const ItemsPage(),
          Container(color: Colors.accents[1],),
          Container(color: Colors.accents[2],),
          Container(color: Colors.accents[3],),
        ],
      )
    );
  }
}
