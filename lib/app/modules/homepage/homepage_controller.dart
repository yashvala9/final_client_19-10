import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';
import '../../../models/comment.dart';
import '../../../models/reel_model.dart';

class HomePageController extends GetxController {
  final _reelRepo = Get.put(ReelRepository());
  final _authService = Get.put(AuthService());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  bool _showLike = false;
  bool get showLike => _showLike;
  set showLike(bool showLike) {
    _showLike = showLike;
    update();
  }

  List<ReelModel> _reelList = [];
  List<ReelModel> get reelList => _reelList;
  set reelList(List<ReelModel> reelList) {
    _reelList = reelList;
    update();
  }

  final Rx<List<Comment>> _comments = Rx<List<Comment>>([
    Comment(
        username: "yashvala9",
        comment: "comment",
        datePublished: "datePublished",
        likes: [],
        profilePhoto: "profilePhoto",
        uid: "1",
        id: "1")
  ]);
  List<Comment> get comments => _comments.value;

  @override
  void onInit() {
    getFeeds();
    super.onInit();
  }

  void getFeeds() async {
    loading = true;
    try {
      reelList = await _reelRepo.getFeeds(profileId!, token!);
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("getFeeds: $e");
    }
    loading = false;
  }

  void toggleLikeShow() async {
    showLike = true;
    await Future.delayed(
        const Duration(milliseconds: 1000), () => showLike = false);
  }

  void likeToggle(int index) async {
    // print("Index: $index");
    // if (reelList[index].isLiked) {
    //   reelList[index].likeCount--;
    // } else {
    //   toggleLikeShow();
    //   reelList[index].likeCount++;
    // }
    // reelList[index].isLiked = !reelList[index].isLiked;
    // _reelRepo.toggleLike(reelList[index].reelId, profileId!, token!);
    // update();
  }

  void signOut() {
    _authService.signOut();
  }
}
