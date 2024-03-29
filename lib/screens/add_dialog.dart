import 'package:flutter/material.dart';
import 'package:watch_list/services/database.dart';
import '../shared/movie_data.dart';

class AddDialog extends StatefulWidget {
  AddDialog(
      {Key? key,
      required this.uid,
      required this.onMovieAdded,
      required this.movies})
      : super(key: key);

  final List<List<MovieData>> movies;
  final String uid;
  final Future<void> Function() onMovieAdded;

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final TextEditingController _titleController = TextEditingController();
  MovieStatus _selectedStatus = MovieStatus.planned;
  int _selectedScore = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value, List<MovieData> movies) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }

    if (movies
        .any((movie) => movie.title.toLowerCase() == value.toLowerCase())) {
      return 'A movie with this title already exists';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Movie'),
      content: SingleChildScrollView(
        // Wrap the content in SingleChildScrollView
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => _validateTitle(value,
                    widget.movies[0] + widget.movies[1] + widget.movies[2]),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedScore,
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      _selectedScore = value;
                    });
                  }
                },
                items: List.generate(11, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text((index).toString()),
                  );
                }),
                decoration: const InputDecoration(labelText: 'Score'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MovieStatus>(
                value: _selectedStatus,
                onChanged: (MovieStatus? value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
                items: MovieStatus.values.map((status) {
                  return DropdownMenuItem<MovieStatus>(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final databaseService = DatabaseService(uid: widget.uid);
              final String title = _titleController.text.trim();
              final MovieData movieData = MovieData(
                title: title,
                status: _selectedStatus,
                score: _selectedScore,
              );

              Navigator.of(context).pop();
              await databaseService.addMovie(movieData);
              await widget.onMovieAdded();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
