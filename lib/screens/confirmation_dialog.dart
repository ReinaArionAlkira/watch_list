import 'package:flutter/material.dart';
import 'package:watch_list/services/database.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  ConfirmationDialogWidget(
      {required this.title,
      required this.content,
      required this.databaseService,
      super.key});

  final String content;
  final String title;
  final DatabaseService databaseService;
  bool deleteAll = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Confirm"),
          onPressed: () {
            deleteAll = true;
            Navigator.of(context).pop(deleteAll);
          },
        ),
      ],
    );
  }
}
