import 'package:apple_market/src/states/user_provider.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('HomeScreen >> build');
    logger.d('current user state: ${context.read<UserProvider>().userState }');

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              context.read<UserProvider>().setUserAuth(false);
            },
            icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: TextButton(
          child: const Text('Log out'),
          onPressed: () {
            context.read<UserProvider>().setUserAuth(false);
          },
        ),
      ),
    );
  }
}
