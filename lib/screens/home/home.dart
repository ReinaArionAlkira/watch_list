import "package:flutter/material.dart";
import "package:watch_list/services/auth.dart";

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
    );
  }
}
