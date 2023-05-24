import 'package:flutter/material.dart';
import 'package:watch_list/services/auth.dart';
import 'package:watch_list/shared/movie_data.dart';

import '../../services/database.dart';

class ListOfMovies extends StatelessWidget {
  ListOfMovies({required this.stream, this.onDelete, super.key});

  final void Function(MovieData movie)? onDelete;
  final Stream<List<MovieData>> stream;
  final DatabaseService databaseService =
      DatabaseService(uid: AuthService().getUid());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MovieData>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data;
            if (movies!.isEmpty) {
              return const Card(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'No movies found',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
            return Flexible(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      // onTap: (() {
                      //   MaterialPageRoute route =
                      //       MaterialPageRoute(builder: (BuildContext context) {
                      //     return EditMovieWidget(
                      //       student: movies[index],
                      //     );
                      //   });
                      //   Navigator.of(context).push(route);
                      // }),
                      title: Text(movies[index].title),
                      subtitle:
                          Text('Score: ${movies[index].score.toString()}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onDelete != null
                            ? () => onDelete!(movies[index])
                            : () {
                                databaseService.deleteMovie(movies[index].id!);
                              },
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator()],
            ));
          }
        });
  }
}
