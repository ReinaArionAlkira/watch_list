import "package:flutter/material.dart";
import "package:watch_list/screens/confirmation_dialog.dart";
import "package:watch_list/screens/movies_screen.dart";
import "package:watch_list/services/auth.dart";
import "package:watch_list/services/database.dart";

import "../add_dialog.dart";

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final uid = _auth.getUid();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: MoviesScreen(
        databaseService: DatabaseService(uid: uid),
      ),
    );
  }
}
