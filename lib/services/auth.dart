import "dart:async";

import "package:firebase_auth/firebase_auth.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // auth change user stream
  Stream<User?> get user async* {
    final User? initialUser = await _auth.authStateChanges().first;
    yield initialUser;
    yield* _auth.authStateChanges();
  }

  // sign in anonimous
  Future signInAnom() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & pass

  // register with email & pass
  Future registerWithEmailAndPass(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
