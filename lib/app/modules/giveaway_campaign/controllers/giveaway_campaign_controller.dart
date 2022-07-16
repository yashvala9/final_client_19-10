import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';

import '../../../../services/auth_service.dart';
import '../../../../utils/snackbar.dart';

class GiveawayCampaignController extends GetxController {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _authService = Get.put(AuthService());

  String? get token => _authService.token;
  bool loading = false;
  late File? photo;
  String campaignName = '';
  String prizeName = '';
  DateTime endDate = DateTime.parse("2022-08-11");
  int photoId = 0;
  RxString photoUrl = ''.obs;
  RxBool photoLoading = false.obs;

  void createGiveaway() async {
    loading = true;
    print('21212121 $campaignName');
    print('21212121 $endDate');
    try {
      var map = {
        "createdBy": _authService.profileModel!.id,
        "creatorType": "admin",
        "name": campaignName,
        "rules": "I lob u gal",
        "startDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "endDate": DateFormat("yyyy-MM-dd").format(endDate),
        "prize": {"img": photoId, "name": prizeName},
        "prizeCount": 1,
        "minimumEligibilityCriteria": "others"
      };
      // var map1 = {
      //   "contestName": campaignName,
      //   "createdBy": 14,
      //   "creatorType": "admin",
      //   "startDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      //   "endDate": DateFormat("yyyy-MM-dd").format(endDate),
      //   "rules": "Rule 1b, Rule 2b, Rule 3b",
      //   "minimumEligibilityCriteria": "follower",
      //   "prizeCount": 1,
      //   "prizes": [4]
      // };
      print('21212121 $map');
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

  void uploadImage() async {
    photoLoading(true);
    var v = await _giveawayRepo.addPhoto(photo!, token!);
    photoId = v['id'];
    photoUrl.value = v['url'];
    printInfo(info: photoUrl.value);
    photoLoading(false);
  }
}
