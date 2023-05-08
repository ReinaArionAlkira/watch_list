import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:watch_list/screens/home/home.dart";

import "authenticate/authenticate.dart";

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print(user);

    // Home or Authenticate Widget
    return user != null ? Home() : const Authenticate();
  }
}
