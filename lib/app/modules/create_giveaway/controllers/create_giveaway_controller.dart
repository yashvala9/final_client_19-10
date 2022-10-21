import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';
import 'package:intl/intl.dart';

import '../../../../repositories/profile_repository.dart';
import '../../../../services/auth_service.dart';
import '../../../../utils/snackbar.dart';
import 'package:path/path.dart' as path;

class CreateGiveawayController extends GetxController {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _authService = Get.put(AuthService());
  final _profileRepo = Get.put(ProfileRepository());

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
  DateTime endDate = DateTime.parse("2022-08-11").toUtc();
  int photoId = 0;
  RxString photoUrl = ''.obs;
  RxBool photoLoading = false.obs;

  Future<void> createGiveaway() async {
    if (file == null) {
      showSnackBar("Please add giveaway image", color: Colors.red);
      return;
    }
    loading = true;
    try {
      String _fileName = '';
      if (file != null) {
        file = await changeFileNameOnly(file!, 'prizeImage');
        _fileName = genFileName("Profile", path.basename(file!.path));

        final s3File = await _profileRepo.uploadProfileToAwsS3(
            userID: "Profile", file: file!, fileName: _fileName);

        debugPrint('2121' + s3File.toString());
      }

      var map = {
        "contest_name": campaignName,
        "creator_type": "INFLUENCER",
        "creator_id": _authService.profileModel!.id,
        "start_date": DateTime.now().toUtc().toString(),
        "end_date": endDate.toUtc().toString(),
        "rules": "1. Rule No 1, 2. Rule No 2, 3. Rule No 3",
        "prize_count": 1,
        "prize": {
          "prize_name": prizeName,
          "prize_image": _fileName,
          "prize_description": ""
        }
      };

      await _giveawayRepo.createGiveaway(map, token!);
      Get.back();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("createGiveaway: $e");
    }
    loading = false;
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var filepath = file.path;
    var lastSeparator = filepath.lastIndexOf(Platform.pathSeparator);
    var extension = path.extension(file.path).toString();
    var newPath =
        filepath.substring(0, lastSeparator + 1) + newFileName + extension;
    return file.rename(newPath);
  }

  String genFileName(String userID, String fileName) {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    return 'reel_${userID}_${date}_${timestamp}_$fileName';
  }

  void uploadImage() async {
    photoLoading(true);
    var v = await _giveawayRepo.addPhoto(photo!, token!);
    photoId = v['id'];
    photoUrl.value = v['url'];
    photoLoading(false);
  }
}
