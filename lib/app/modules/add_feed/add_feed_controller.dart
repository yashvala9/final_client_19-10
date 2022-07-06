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

  void addFeed() async {
    loading = true;
    var data = {
      "userId": profileId!,
      "description": descriptionn,
      "videoTitle": title,
      "video": "",
      'tags': [],
      'song': "",
      "type": 0,
    };
    try {
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
