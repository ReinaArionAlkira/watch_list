import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_list/shared/movie_data.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  // collection reference

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  // add
  Future<void> addMovie(MovieData movieData) async {
    return await usersCollection
        .doc(uid)
        .collection("movies")
        .doc()
        .set(movieData.toMap());
  }

  // delete
  Future<void> deleteMovie(String movieId) async {
    return await usersCollection
        .doc(uid)
        .collection("movies")
        .doc(movieId)
        .delete();
  }

  Future<void> deleteAllMovies() async {
    try {
      QuerySnapshot snapshot =
          await usersCollection.doc(uid).collection("movies").get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  // list by status
  Future<List<MovieData>> listByStatus(String status) async {
    var data = await usersCollection
        .doc(uid)
        .collection("movies")
        .where("status", isEqualTo: status)
        .get();
    print(
        "Staaaaaaaaaaaaaaaaaaaaaaa${data.docs.map((e) => MovieData.fromMap(e.data(), e.id)).toList()}");
    return data.docs.map((e) => MovieData.fromMap(e.data(), e.id)).toList();
  }

  // update
  Future<void> updateMovie(String movieId, MovieData movieData) async {
    return await usersCollection
        .doc(uid)
        .collection("movies")
        .doc(movieId)
        .set(movieData.toMap());
  }
}
