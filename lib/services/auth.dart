import 'package:firebase_auth/firebase_auth.dart';

import '../models/userFirebase.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*
    TODO: login
  */
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      print(e.toString());
    }
  }

  /*
    TODO: signup
  */
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return result.user!.uid;
    } catch (e) {
      print(e.toString());
    }
  }

  /*
    TODO: reset password
  */
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  /*
    TODO: logout
  */
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
