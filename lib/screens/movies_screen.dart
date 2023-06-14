import 'package:flutter/material.dart';
import 'package:watch_list/screens/add_dialog.dart';
import 'package:watch_list/screens/confirmation_dialog.dart';
import 'package:watch_list/screens/edit_dialog.dart';
import 'package:watch_list/services/database.dart';
import 'package:watch_list/shared/movie_data.dart';

class MoviesScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const MoviesScreen({Key? key, required this.databaseService})
      : super(key: key);

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  bool _isSortedByScore = false;
  bool _isSortedByName = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _selectedMovies =
            _watchedMovies.toList(); // Update the selected movies list
      } else if (index == 1) {
        _selectedMovies =
            _watchingMovies.toList(); // Update the selected movies list
      } else if (index == 2) {
        _selectedMovies =
            _plannedMovies.toList(); // Update the selected movies list
      }
    });
  }

  List<MovieData> _watchedMovies = [];
  List<MovieData> _watchingMovies = [];
  List<MovieData> _plannedMovies = [];

  List<MovieData> _selectedMovies = [];
  List<MovieData> _searchedMovies = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    _watchedMovies =
        await widget.databaseService.listByStatus(MovieStatus.watched.value);
    _watchingMovies =
        await widget.databaseService.listByStatus(MovieStatus.watching.value);
    _plannedMovies =
        await widget.databaseService.listByStatus(MovieStatus.planned.value);
    List<List<MovieData>> movieLists = [
      _watchedMovies,
      _watchingMovies,
      _plannedMovies,
    ];
    setState(() {
      _selectedMovies =
          movieLists[_selectedIndex]; // Set the initial selected movies list
    });
  }

  Future<void> _deleteMovie(String movieId) async {
    await widget.databaseService.deleteMovie(movieId);
    await _loadMovies();
  }

  Future<void> _deleteAllMovies() async {
    final deleteAll = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialogWidget(
          title: "Reset Database!",
          content: "Are you sure, you want to delete all data?",
          databaseService: widget.databaseService),
    );
    if (deleteAll == true) {
      await widget.databaseService.deleteAllMovies();
      await _loadMovies();
    }
  }

  Future<void> _editMovie(String movieId, MovieData movie) async {
    final editedMovie = await showDialog<MovieData>(
      context: context,
      builder: (context) => EditDialog(
        uid: widget.databaseService.uid,
        movieData: movie,
        movies: [_watchedMovies, _watchingMovies, _plannedMovies].toList(),
      ),
    );

    if (editedMovie != null) {
      await widget.databaseService.updateMovie(movieId, editedMovie);
      await _loadMovies();
    }
  }

  void _toggleSortByScore() {
    setState(() {
      _isSortedByScore = !_isSortedByScore;
      _isSortedByName = false; // Reset the sorting by name state

      if (_isSortedByScore) {
        _selectedMovies.sort((a, b) => a.score.compareTo(b.score));
      } else {
        _selectedMovies.sort(
            (a, b) => b.score.compareTo(a.score)); // Reverse the sorting order
      }
    });
  }

  void _toggleSortByName() {
    setState(() {
      _isSortedByName = !_isSortedByName;
      _isSortedByScore = false; // Reset the sorting by score state

      if (_isSortedByName) {
        _selectedMovies.sort((a, b) => a.title.compareTo(b.title));
      } else {
        _selectedMovies.sort(
            (a, b) => b.title.compareTo(a.title)); // Reverse the sorting order
      }
    });
  }

  void _searchMovies(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchedMovies.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchedMovies = _selectedMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildMoviesList(List<MovieData> movies) {
    return ListView.builder(
      itemCount: movies.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSortByRow();
        } else if (index == 1) {
          return _buildSearchBar();
        } else {
          final movieIndex = index - 2;
          final movie = movies[movieIndex];
          return ListTile(
            title: Text(movie.title),
            subtitle: Text(movie.score == 0 ? "" : "Score: ${movie.score}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editMovie(movie.id!, movie),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteMovie(movie.id!),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSortByRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text('Sort by:'),
          Expanded(
            child: TextButton(
              onPressed: _toggleSortByScore,
              child: Text('Score'),
              style: TextButton.styleFrom(
                backgroundColor: _isSortedByScore
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorLight,
                foregroundColor: _isSortedByScore
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: _toggleSortByName,
              child: Text('Name'),
              style: TextButton.styleFrom(
                backgroundColor: _isSortedByName
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorLight,
                foregroundColor: _isSortedByName
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Expanded(
          child: _isSearching
              ? TextField(
                  onChanged: _searchMovies,
                  decoration: InputDecoration(hintText: 'Search...'),
                )
              : const Text('Search'),
        ),
        IconButton(
          icon:
              _isSearching ? const Icon(Icons.close) : const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
        IconButton(
          padding: const EdgeInsets.only(right: 16.0),
          icon: const Icon(Icons.delete),
          onPressed: () => setState(_deleteAllMovies),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMoviesList(_isSearching ? _searchedMovies : _selectedMovies),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        fixedColor: Theme.of(context).primaryColorLight,
        unselectedItemColor: Theme.of(context).primaryColorDark,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Watched',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Watching',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planned',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddDialog(
              movies:
                  [_watchedMovies, _watchingMovies, _plannedMovies].toList(),
              onMovieAdded: _loadMovies,
              uid: widget.databaseService.uid,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
