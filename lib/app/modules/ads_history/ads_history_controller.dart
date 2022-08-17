import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/ads_history_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:video_player/video_player.dart';

import '../../../models/photo_model.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/reel_repository.dart';
import '../../../services/auth_service.dart';
import '../../../utils/snackbar.dart';

class AdsHistoryController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _profileRepo = Get.put(ProfileRepository());
  final _reelRepo = Get.put(ReelRepository());
  final _authRepo = Get.put(AuthRepository());

  ProfileModel get profileModel => _authService.profileModel!;

  late List<AdsHistoryModel> adsHistory = [];

  int? get profileId => _authService.profileModel?.id;
  String? get token => _authService.token;

  bool loadingMore = false;
  bool _loadMore = true;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  // Future<void> getMoreFeed(int skip) async {
  //   loadingMore = true;
  //   if (_loadMore) {
  //     try {
  //       var newList = await _profileRepo.getReelByProfileId(profileId!, token!,
  //           limit: 9, skip: skip);
  //       if (newList.isEmpty) {
  //         _loadMore = false;
  //       } else {
  //         reelsLoaded.addAll(newList);
  //       }
  //     } catch (e) {
  //       showSnackBar(e.toString(), color: Colors.red);
  //       print("getFeeds: $e");
  //     }
  //   }
  //   loadingMore = false;
  // }
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
  // void signOut() async {
  //   await _authRepo.signOut();
  // }

  // void deleteReel(int reelId) async {
  //   try {
  //     await _reelRepo.deleteReel(reelId, token!);
  //     update();
  //   } catch (e) {
  //     print('delteReel: $e');
  //   }
  // }
}
