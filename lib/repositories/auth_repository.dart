import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> sendPasswordResetLink(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithGoogle() async {
    await _googleSignIn.disconnect();
    
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<void> addProfile() async{

  }

  Future<void> forgetPassword() async{}

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
