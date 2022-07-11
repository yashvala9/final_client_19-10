import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';

class AddFeedController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _reelRepo = Get.find<ReelRepository>();

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  String title = "";
  String descriptionn = "";

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  void clean() {
    title = "";
    descriptionn = "";
  }

  // Future<int> uploadVideoOrPhoto(File file) async {
  //   try {
  //     final url = await _reelRepo.addPhotoOrVideo(file,token!);
  //     return url;
  //   } catch (e) {
  //     printInfo(info: "uploadVideoOrPhoto: $e");
  //     showSnackBar(e.toString(), color: Colors.red);
  //     return Future.error(e.toString());
  //   }
  // }

  void addFeed(File file, int type) async {
    loading = true;
    var data = {
      "userId": profileId!,
      "description": descriptionn,
      "videoTitle": title,
      "videoId": 0,
      'tags': [],
      'song': "",
      "type": type,
    };
    try {
      final videoId = await _reelRepo.addPhotoOrVideo(file,token!);
      data['videoId'] = videoId;
      await _reelRepo.addReel(data, token!);
      showSnackBar("Reel added successfully");
      clean();
      Get.back();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("addFeed: $e");
    }
    loading = false;
  }
}
