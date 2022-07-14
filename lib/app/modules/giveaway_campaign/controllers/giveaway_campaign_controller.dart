import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';

import '../../../../services/auth_service.dart';
import '../../../../utils/snackbar.dart';

class GiveawayCampaignController extends GetxController {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _authService = Get.put(AuthService());

  String? get token => _authService.token;
  bool loading = false;

  String campaignName = '';
  String prizeName = '';
  DateTime endDate = DateTime.parse("2022-08-11");

  void createGiveaway() async {
    loading = true;
    try {
      var map = {
        "contestName": "Test Contest",
        "createdBy": 14,
        "creatorType": "verifiedUser",
        "startDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "endDate": "2022-07-18",
        "rules": "Rule 1b, Rule 2b, Rule 3b",
        "minimumEligibilityCriteria": "follower",
        "prizeCount": 1,
        "prizes": [4]
      };
      await _giveawayRepo.createGiveaway(map, token!);
      // _storage.write(Constants.token, token);
      // await _userRepo.createProfile(userModel);
      // _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("login: $e");
    }
    loading = false;
  }
}
