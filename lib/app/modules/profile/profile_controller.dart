import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:video_player/video_player.dart';

import '../../../models/photo_model.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/reel_repository.dart';
import '../../../services/auth_service.dart';
import '../../../utils/snackbar.dart';

class ProfileController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _profileRepo = Get.put(ProfileRepository());
  final _reelRepo = Get.put(ReelRepository());
  ProfileModel get profileModel => _authService.profileModel!;
  late List<ReelModel> reels = [];
  late List<PhotoModel> photos = [];
  final _authRepo = Get.put(AuthRepository());

  int? get profileId => _authService.profileModel?.id;
  String? get token => _authService.token;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  @override
  void onInit() {
    print('2121 on init called');
    super.onInit();
  }

  // void getProfile() async {
  //   loading = true;
  //   try {
  //     profileModel = await _profileRepo.getProfileById(profileId!, token!);
  //   } catch (e) {
  //     showSnackBar(e.toString(), color: Colors.red);
  //     print("getProfile: $e");
  //   }
  //   loading = false;
  // }

  // void getReelsById() async{
  //   try {

  //   } catch (e) {
  //     print("getReelsById: $e");
  //   }
  // }
  void signOut() async {
    await _authRepo.signOut();
  }

  void deleteReel(int reelId) async {
    try {
      await _reelRepo.deleteReel(reelId, token!);
      update();
    } catch (e) {
      print('delteReel: $e');
    }
  }
}
