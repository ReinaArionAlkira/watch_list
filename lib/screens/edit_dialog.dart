import 'package:flutter/material.dart';
import 'package:watch_list/shared/movie_data.dart';

class EditDialog extends StatefulWidget {
  final String uid;
  final MovieData movieData;
  final List<List<MovieData>> movies;

  const EditDialog(
      {Key? key,
      required this.uid,
      required this.movieData,
      required this.movies})
      : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _titleController;
  late MovieStatus _selectedStatus;
  late int _selectedScore;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movieData.title);
    _selectedStatus = widget.movieData.status;
    _selectedScore = widget.movieData.score;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value, List<MovieData> movies) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }

    // Exclude the current movie being edited from the duplicate title check
    final editedMovieId = widget.movieData.id;
    if (movies.any((movie) =>
        movie.title.toLowerCase() == value.toLowerCase() &&
        movie.id != editedMovieId)) {
      return 'A movie with this title already exists';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Movie'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => _validateTitle(value,
                      widget.movies[0] + widget.movies[1] + widget.movies[2])),
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
                items: List.generate(11, (index) => index)
                    .map<DropdownMenuItem<int>>((int score) {
                  return DropdownMenuItem<int>(
                    value: score,
                    child: Text(score.toString()),
                  );
                }).toList(),
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
                items: MovieStatus.values
                    .map<DropdownMenuItem<MovieStatus>>((status) {
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final editedMovie = MovieData(
                title: _titleController.text.trim(),
                status: _selectedStatus,
                score: _selectedScore,
              );
              Navigator.of(context).pop(editedMovie);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
