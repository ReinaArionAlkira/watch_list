import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:watch_list/shared/movie_data.dart';

class EditMovieWidget extends StatefulWidget {
  const EditMovieWidget({required this.movie, super.key});

  final MovieData movie;

  @override
  State<EditMovieWidget> createState() => _EditMovieWidgetState();
}

class _EditMovieWidgetState extends State<EditMovieWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
