import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';

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

  int? get profileId => _authService.profileModel?.id;
  String? get token => _authService.token;

  bool loadingMore = false;
  bool _loadMore = true;
  List<ReelModel> reelsLoaded = [];

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    debugPrint('On Init running');
    isLoading(true);
    await getReels();
    await getPhotos();
    isLoading(false);
    super.onInit();
  }

  Future<void> getReels() async {
    reels = await _profileRepo.getReelByProfileId(profileId!, token!,
        limit: 500, skip: 0);
  }

  Future<List<ReelModel>> getReelFuture() async {
    return reels;
  }

  Future<void> getPhotos() async {
    photos = await _profileRepo.getPhotosByProfileId(profileId!, token!);
  }

  Future<List<PhotoModel>> getPhotoFuture() async {
    return photos;
  }

  Future<void> getMoreFeed(int skip) async {
    loadingMore = true;
    if (_loadMore) {
      try {
        var newList = await _profileRepo.getReelByProfileId(profileId!, token!,
            limit: 9, skip: skip);
        if (newList.isEmpty) {
          _loadMore = false;
        } else {
          reelsLoaded.addAll(newList);
        }
      } catch (e) {
        showSnackBar(e.toString(), color: Colors.red);
        debugPrint("getFeeds: $e");
      }
    }
    loadingMore = false;
  }

  void updateManually() {
    update();
  }

  void deleteReel(int reelId) async {
    try {
      await _reelRepo.deleteReel(reelId, token!);
      reels.removeWhere(
        (element) => element.id == reelId,
      );
      update();
    } catch (e) {
      debugPrint('delteReel: $e');
    }
  }

  void deletePost(int postId) async {
    try {
      await _reelRepo.deletePost(postId, token!);
      photos.removeWhere(
        (element) => element.id == postId,
      );
      update();
      onInit();
    } catch (e) {
      debugPrint('deletePost: $e');
    }
  }
}
