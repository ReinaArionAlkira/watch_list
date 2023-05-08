import "package:flutter/material.dart";
import "package:watch_list/services/auth.dart";
import "package:watch_list/shared/loading.dart";

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // fields state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text("Sign In"),
              actions: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: const Icon(Icons.person),
                  label: const Text("Register"),
                )
              ],
            ),
            body: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'Email'),
                          validator: (value) =>
                              value!.isEmpty ? "Enter an email" : null,
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Password'),
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
                          child: const Text("Sign In",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPass(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      "please supply a valid email or password";
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ))),
          );
  }
}
