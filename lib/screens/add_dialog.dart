import 'package:flutter/material.dart';
import 'package:watch_list/services/database.dart';
import 'package:watch_list/shared/movie_data.dart';

import '../services/auth.dart';

class AddDialog extends StatefulWidget {
  AddDialog({super.key});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  void onSubmit(movieData) async {
    DatabaseService databaseService =
        DatabaseService(uid: AuthService().getUid());
    await databaseService.addMovie(movieData);
  }

  static final _formKey = GlobalKey<FormState>();

  String name = "";

  final List<int> scores = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int score = 1;

  final List<MovieStatus> statuss = MovieStatus.values.toList();
  MovieStatus status = MovieStatus.watching;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => setState(() => name = value),
              onSaved: (value) => name = value ?? "",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some data';
                }
                return null;
              },
              controller: TextEditingController(text: name)
                ..selection = TextSelection.collapsed(offset: name.length),
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
                hintText: "Name",
              ),
            ),
            DropdownButtonFormField(
                items: scores
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => score = value ?? score)),
            DropdownButtonFormField(
                items: statuss
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => status = value ?? status)),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Processing Data')),
                  // );
                  onSubmit(
                      MovieData(title: name, status: status, score: score));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
