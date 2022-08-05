import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';

import '../../../../services/auth_service.dart';
import '../../../../utils/snackbar.dart';

class CreateGiveawayController extends GetxController {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _authService = Get.put(AuthService());

  File? _file;
  File? get file => _file;
  set file(File? image) {
    _file = image;
    update();
  }

  String? get token => _authService.token;
  bool loading = false;
  late File? photo;
  String campaignName = '';
  String prizeName = '';
  DateTime endDate = DateTime.parse("2022-08-11");
  int photoId = 0;
  RxString photoUrl = ''.obs;
  RxBool photoLoading = false.obs;

  Future<void> createGiveaway() async {
    loading = true;
    print('21212121 $campaignName');
    print('21212121 ${endDate.toString()}');
    try {
      var map = {
        "contest_name": campaignName,
        "creator_type": "INFLUENCER",
        "creator_id": _authService.profileModel!.id,
        "start_date": DateTime.now().toString(),
        "end_date": endDate.toString(),
        "rules": "My life My rules",
        "prize_count": 1,
        "prize": {
          "prize_name": prizeName,
          "prize_image": photoUrl.value,
          "prize_description": ""
        }
      };
      print('21212121 $map');
      await _giveawayRepo.createGiveaway(map, token!);
      Get.back();

      // _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("createGiveaway: $e");
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
