import 'dart:convert';
import 'dart:io';

import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/contest_model.dart';
import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/winner_model.dart';

import '../models/profile_model.dart';
import '../models/reel_model.dart';
import '../utils/base.dart';
import '../utils/snackbar.dart';

class GiveawayRepository {
  Future<void> createGiveaway(
      Map<String, dynamic> giveawayData, String token) async {
    final response = await http.post(
      Uri.parse(Base.CreateGiveaway),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(giveawayData),
    );
    final body = jsonDecode(response.body);
    print('21212121 ${response.body}');
    if (response.statusCode == 200) {
      showSnackBar(response.body);
      return;
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<String> getAdsEntryCountByUserId(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getTotalEntryCountByUserId}?userId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print('list21213 ' + body.toString());

    if (response.statusCode == 200) {
      return body['data']['adEntries'].toString();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<String> getReferralsEntryCountByUserId(
      int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getTotalEntryCountByUserId}?userId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print('list21213 ' + body.toString());

    if (response.statusCode == 200) {
      return body['data']['referralEntries'].toString();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<String> getTotalEntryCountByUserId(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getTotalEntryCountByUserId}?userId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print('list21213 ' + body.toString());

    if (response.statusCode == 200) {
      return body['data']['totalEntries'].toString();
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<List<String>> getBuddyPairByUserId(int profileId, String token) async {
    List<String> list = [];
    final response = await http.get(
      Uri.parse("${Base.getBuddyPairByUserId}?userId=14"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    // print('list2121 ' + body.toString());

    if (response.statusCode == 200) {
      list.add(body['data']['profileUrl'].toString());
      list.add(body['data']['fullname'].toString());
      return list;
    } else {
      list.add('');
      list.add('Not available');
      return list;
    }
  }

  Future<List<ContestModel>> getContests(int profileId, String token) async {
    List<ContestModel> contests = [];
    final response = await http.get(
      Uri.parse(Base.giveaway),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print('list212121body $body');
    if (response.statusCode == 200) {
      for (var item in body) {
        var cm = ContestModel(
            id: item['id'] as int,
            createdBy: item['createdBy']['id'] ?? 0,
            contestName: (item['contestName'] ?? '') as String,
            endDate: DateTime.parse((item['endDate'] ?? '') as String),
            creatorType: (item['creatorType'] ?? '') as String,
            prizeName:
                // '',
                (item['prizes'] as List<dynamic>).isNotEmpty
                    ? (item['prizes'][0]['prizeName'] ?? '') as String
                    : '',
            prizeImageUrl:
                'https://reelro-strapi.s3.ap-south-1.amazonaws.com/image_picker1761878752343692204_9ff2c4915a.jpg',
            rules: (item['rules'] ?? '') as String);

        contests.add(cm);
      }
      return contests;
    } else {
      return Future.error(body);
    }
  }

  Future<ContestModel> getContestsByUserId(int profileId, String token) async {
    ContestModel contest;
    final response = await http.get(
      Uri.parse('${Base.giveaway}?createdBy=$profileId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print('list212121body');
    print('list212121body $body[0]');
    if (response.statusCode == 200) {
      contest = ContestModel(
        id: body[0]['id'] as int,
        createdBy: body[0]['createdBy']['id'] ?? 0,
        contestName: (body[0]['contestName'] ?? '') as String,
        endDate: DateTime.parse((body[0]['endDate'] ?? '') as String),
        creatorType: (body[0]['creatorType'] ?? '') as String,
        prizeName:
            // '',
            (body[0]['prizes'] as List<dynamic>).isNotEmpty
                ? (body[0]['prizes'][0]['prizeName'] ?? '') as String
                : '',
        prizeImageUrl:
            'https://reelro-strapi.s3.ap-south-1.amazonaws.com/image_picker1761878752343692204_9ff2c4915a.jpg',
        rules: (body[0]['rules'] ?? '') as String,
      );

      return contest;
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
    print('list212121winnerbody $body');
    if (response.statusCode == 200) {
      for (var item in body) {
        var winner = WinnerModel(
            id: (item['id'] ?? 0) as int,
            contestName: (item['contestId']['contestName'] ?? '') as String,
            prizeName: 'prizename',
            // (item['prizes'][0]['prizeName'] ?? '') as String,
            winnerName: 'WinnerName',
            //item['profileId']['fullname'],
            winnerImageUrl: 'WinnerUrl'
            // item['profileId']['profileUrl']
            );
        print('list212121winnerbody ${winner.toString()}');
        winners.add(winner);
      }
      return winners;
    } else {
      return Future.error(body);
    }
  }

  Future<Map<String, dynamic>> addPhoto(File file, String token) async {
    printInfo(info: "File path: ${file.path}");
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
}
