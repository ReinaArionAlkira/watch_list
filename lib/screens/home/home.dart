import "package:flutter/material.dart";
import "package:watch_list/screens/home/list_of_movies.dart";
import "package:watch_list/services/auth.dart";
import "package:watch_list/services/database.dart";
import "package:watch_list/shared/movie_data.dart";

import "../add_dialog.dart";

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;

  static final List<Widget> _dialogOptions = <Widget>[AddDialog()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future openDialog(Widget element) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: const Text('Add'), content: element),
      );

  void submit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.getUid();
    final DatabaseService movies = DatabaseService(uid: uid);
    final List<Widget> widgetOptions = <Widget>[
      ListOfMovies(stream: movies.listByStatusListen(MovieStatus.watched)),
      ListOfMovies(stream: movies.listByStatusListen(MovieStatus.watching)),
      ListOfMovies(stream: movies.listByStatusListen(MovieStatus.planned)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    child: TextField(
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.justify,
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(),
                          hintText: 'Search',
                        )),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  // Expanded(
                  //     child: TextFormField(
                  //         textAlign: TextAlign.center,
                  //         style: const TextStyle(fontWeight: FontWeight.bold),
                  //         decoration: const InputDecoration(
                  //           border: InputBorder.none,
                  //         ),
                  //         readOnly: true,
                  //         controller: TextEditingController(
                  //             text:
                  //                 "A d d   s o m e   r e c o r d s   t o   l i s t"))),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // in future more add options
                      openDialog(_dialogOptions.elementAt(0));
                    },
                  ),
                ]),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
          //TODO:
          // DropdownButton(items: items, onChanged: onChanged),
          widgetOptions.elementAt(_selectedIndex),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_rounded),
            label: 'Watched',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined),
            label: 'Watching',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Planning',
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        fixedColor: Theme.of(context).primaryColorLight,
        unselectedItemColor: Theme.of(context).primaryColorDark,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
