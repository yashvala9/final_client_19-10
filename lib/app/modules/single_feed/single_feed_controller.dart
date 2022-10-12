import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';

class SingleFeedController extends GetxController {
  final _reelRepo = Get.put(ReelRepository());
  final _authService = Get.put(AuthService());
  final _profileRepo = Get.put(ProfileRepository());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  List<int> reportList = [];
  bool _showLike = false;
  bool get showLike => _showLike;
  set showLike(bool showLike) {
    _showLike = showLike;
    update();
  }

  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([
    // Comment(
    //     username: "yashvala9",
    //     comment: "comment",
    //     datePublished: "datePublished",
    //     likes: [],
    //     profilePhoto: "profilePhoto",
    //     uid: "1",
    //     id: "1")
  ]);
  List<CommentModel> get comments => _comments.value;

  @override
  void onInit() {
    // getFeeds();
    super.onInit();
  }

  void toggleLikeShow() async {
    showLike = true;
    await Future.delayed(
        const Duration(milliseconds: 1000), () => showLike = false);
  }

  void likeToggle(int id, {bool isPhoto = false}) async {
    try {
      bool isLiked = false;
      if (isPhoto) {
        await _reelRepo.photoToggleLike(id, token!);
        isLiked = await _reelRepo.getPhotosLikeFlag(id, token!);
      } else {
        await _reelRepo.toggleLike(id, token!);
        isLiked = await _reelRepo.getLikeFlag(id, token!);
      }
      if (isLiked) {
        toggleLikeShow();
      }
    } catch (e) {
      log("TogglelikeError: $e");
    }
    update();
  }

  void phototLikeToggle(int id) async {
    try {
      await _reelRepo.photoToggleLike(id, token!);
      final isLiked = await _reelRepo.getPhotosLikeFlag(id, token!);
      if (isLiked) {
        toggleLikeShow();
      }
      update();
    } catch (e) {
      print("TogglelikeError: $e");
    }
    update();
  }

  void toggleFollowing(int id) async {
    try {
      _profileRepo.toggleFollow(id, token!);
      update();
    } catch (e) {
      log("toggleFollowingError: $e");
    }
  }
}

class CommentController extends GetxController {
  CommentController({required this.reelId});
  final int reelId;
  final _commentRepo = Get.put(CommentRepository());
  final _authService = Get.put(AuthService());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;
  ProfileModel get profileModel => _authService.profileModel!;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  List<CommentModel> _commentList = [];
  List<CommentModel> get commentList => _commentList;
  set commentList(List<CommentModel> commentList) {
    _commentList = commentList;
    update();
  }

  String comment = "";

  @override
  void onInit() {
    customeInit();
    super.onInit();
  }

  void customeInit() {
    clean();
    getCommentsByReelId();
  }

  void clean() {
    commentList.clear();
    comment = "";
  }

  void getCommentsByReelId() async {
    loading = true;
    try {
      commentList = await _commentRepo.getCommentById(reelId, token!);
      print("commentList: $commentList");
    } catch (e) {
      print("getCommentsByReelId: $e");
    }
    loading = false;
  }

  void addCommentLocally(Map<String, dynamic> data) {
    var comment = CommentModel(
        id: 0,
        comment: data['comment'],
        likeCount: 0,
        responseCount: 0,
        user: profileModel,
        isLiked: false,
        createdAt: DateTime.now().toUtc(),
        reelId: reelId.toString());
    _commentList.add(comment);
    update();
  }

  void addComment() async {
    if (comment.isEmpty) {
      showSnackBar("Please add comment", color: Colors.red);
      return;
    }
    var map = {
      'userId': profileId,
      'reelId': reelId,
      'comment': comment.trim(),
    };
    addCommentLocally(map);
    try {
      final message = await _commentRepo.addCommentToById(token!, map, reelId);
      print("addCommentSuccess: $message");
    } catch (e) {
      // showSnackBar(e.toString(), color: Colors.red);
      print("addComment: $e");
    }
  }
}
