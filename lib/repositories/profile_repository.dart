import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:reel_ro/models/profile_model.dart';

import '../utils/base.dart';

class ProfileRepository {
  Future<ProfileModel?> getProfileId(String token) async {
    final response = await http.get(
      Uri.parse(Base.getProfileId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (body['profile'] != null) {
        int profileId = body['profile'];
        return await getProfileById(profileId, token);
      } else {
        return null;
      }
    } else {
      return Future.error(body['message']);
    }
  }

  Future<ProfileModel> getProfileById(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getProfilebyId}/$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ProfileModel.fromMap(body);
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<void> addProfile(
      Map<String, dynamic> profileData, String token) async {
    final response = await http.post(
      Uri.parse(Base.createProfile),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(profileData),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(body['error']['message']);
    }
  }
}
