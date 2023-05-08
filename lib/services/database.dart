import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  // collection reference
  final CollectionReference watchingCollection =
      FirebaseFirestore.instance.collection("users");

  Future updateUserData() async {
    return await watchingCollection.doc(uid).set({
      //"Data" : data
    });
  }
}
