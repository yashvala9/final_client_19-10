import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/contest_model.dart';
import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/winner_model.dart';
import 'package:reel_ro/utils/colors.dart';

import '../models/profile_model.dart';
import '../models/reel_model.dart';
import '../utils/base.dart';
import '../utils/snackbar.dart';

class GiveawayRepository {
  Future<void> createGiveaway(
      Map<String, dynamic> giveawayData, String token) async {
    print(jsonEncode(giveawayData));
    final response = await http.post(
      Uri.parse(Base.giveaway),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(giveawayData),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      showSnackBar("Giveaway created successfully!");
    } else {
      showSnackBar("Giveaway creation failed! please try again.");
    }
  }

  Future<String> getAdsEntryCountByUserId(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.giveaway}$profileId/entries"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['ad_count'].toString();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<String> getReferralsEntryCountByUserId(
      int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.giveaway}$profileId/entries"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['referral_count'].toString();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<String> getTotalEntryCountByUserId(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.giveaway}$profileId/entries"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['total'].toString();
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<List<String>> getBuddyPairByUserId(int profileId, String token) async {
    List<String> list = [];
    final response = await http.get(
      Uri.parse(Base.getBuddyPairByUserId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      list.add(body['profile_img'].toString());
      list.add(body['fullname'].toString());
      return list;
    } else {
      list.add('');
      list.add('Not available');
      return list;
    }
  }

  Future<List<ContestModel>> getContests(int profileId, String token) async {
    try {
      print('212145');
      final response = await http.get(
        Uri.parse('${Base.adminContest}?skip=0&limit=1000'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      final body = jsonDecode(response.body);
      print('list21212145body $body');
      if (response.statusCode == 200) {
        Iterable list = body;
        var v = list.map((e) => ContestModel.fromMap(e)).toList();
        print('212145 $v');
        return v;
      } else {
        return Future.error(body);
      }
    } catch (e) {
      // showSnackBar(e.toString(), color: Colors.red);
      print("getContests: $e");
      return Future.error(e);
    }
  }

  Future<ContestModel?> getContestsByUserId(int profileId, String token) async {
    final response = await http.get(
      Uri.parse('${Base.giveaway}user/$profileId'),
      // user?user_id=$profileId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    // print('list212121body2 $profileId');
    // print('list212121body2 $body');
    if (response.statusCode == 200) {
      if (response.body == "[]") {
        return null;
      }
      return ContestModel.fromMap(body[0]);
    } else {
      return Future.error(body);
    }
  }

  Future<void> deleteContest(int contestId, String token) async {
    final response = await http.delete(
      Uri.parse('${Base.giveaway}delete/$contestId'),
      // user?user_id=$profileId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    // print('212121 $body');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      return Future.error(body);
    }
  }

  Future<List<WinnerModel>> getWinners(int profileId, String token) async {
    List<WinnerModel> winners = [];
    final response = await http.get(
      Uri.parse(Base.winners),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    // print('list212121winnerbody $body');
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => WinnerModel.fromMap(e)).toList();
    } else {
      return Future.error(body);
    }
  }

  Future<Map<String, dynamic>> addPhoto(File file, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Base.imageUpload),
    );
    var headers = <String, String>{
      'Content-Type': 'multipart/form-data; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath('files', file.path),
    );

    var res = await request.send();
    var responsed = await http.Response.fromStream(res);
    var resData = json.decode(responsed.body);
    printInfo(info: resData.toString());
    Map<String, dynamic> map = {
      'id': resData[0]['id'],
      'url': resData[0]['formats']['large']['url']
    };
    if (res.statusCode == 200) {
      return map;
    } else {
      return Future.error(resData['message']);
    }
  }

  Future<List<ProfileModel>> getReferrals(int profileId, String token) async {
    try {
      final response = await http.get(
        Uri.parse(Base.referrals),
        headers: <String, String>{
          // 'accept': '*/*',
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final Iterable list = body;
        return list.map((e) => ProfileModel.fromMap(e)).toList();
      } else {
        return Future.error(body);
      }
    } catch (e) {
      // showSnackBar(e.toString(), color: Colors.red);
      print("getReferrals: $e");
      return Future.error(e);
    }
  }
}
