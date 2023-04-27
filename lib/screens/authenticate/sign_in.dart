import "package:flutter/material.dart";
import "package:watch_list/services/auth.dart";

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // fields state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign In"),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text("Register"),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (value) {
                      setState(() => email = value);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      setState(() => password = value);
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                      onPressed: () async {
                        print(email);
                        print(password);
                      },
                      child: Text("Sign in",
                          style: TextStyle(color: Colors.white)))
                ],
              ))),
    );
  }
}
