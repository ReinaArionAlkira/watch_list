import "package:flutter/material.dart";
import "package:watch_list/screens/home/home.dart";

import "authenticate/authenticate.dart";

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Home or Authenticate Widget
    return Authenticate();
  }
}
