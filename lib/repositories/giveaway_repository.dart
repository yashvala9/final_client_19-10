import 'dart:convert';
import 'dart:io';

import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/photo_model.dart';

import '../models/reel_model.dart';
import '../utils/base.dart';
import '../utils/snackbar.dart';

class GiveawayRepository {
  Future<void> createGiveaway(
      Map<String, dynamic> giveawayData, String token) async {
    final response = await http.post(
      Uri.parse(Base.createGiveaway),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(giveawayData),
    );
    final body = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      showSnackBar(response.body);
      return;
    } else {
      return Future.error(body['error']['message']);
    }
  }
}
