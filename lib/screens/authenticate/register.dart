import "package:flutter/material.dart";
import "package:watch_list/services/auth.dart";

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: const Text("Register In"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(Icons.person),
            label: const Text("Sign in"),
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Enter an email" : null,
                    onChanged: (value) {
                      setState(() => email = value);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    validator: (value) => value!.length < 6
                        ? "Enter password longer than 6"
                        : null,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() => password = value);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    child: const Text("Register",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.registerWithEmailAndPass(
                            email, password);
                        if (result == null) {
                          setState(() => error = "please supply a valid email");
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ))),
    );
  }
}
