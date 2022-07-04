import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reel_ro/utils/constants.dart';

import '../utils/base.dart';

class AuthRepository {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _storage = GetStorage();

  Future<String> signIn(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse(Base.login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode({
        "identifier": email,
        "password": password,
      }),
    );
    final body = jsonDecode(response.body);
    print("signInBody: $body");
    if (response.statusCode == 200) {
      var map = {
        Constants.token: body['jwt'],
        Constants.userId: body['user']['id'],
      };
      await _storage.write(Constants.token, map);
      return "Login successful";
    } else {
      return Future.error(body['message']);
    }
  }

  Future<void> signUp(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(Base.register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(Base.verifyOtp),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var map = {
        Constants.token: body['jwt'],
        Constants.userId: body['user']['id'],
      };
      return map;
    } else {
      return Future.error(body['error']['message']);
    }
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

  Future<void> addProfile() async {}

  Future<void> forgetPassword(String email) async {
    final response = await http.post(
      Uri.parse(Base.register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode({
        "email": email,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<void> signOut() async {
    // await _auth.signOut();
    _storage.remove(Constants.token);
  }
}
