import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/profile_model.dart';

import '../../../models/comment_model.dart';
import '../../../repositories/comment_repository.dart';
import '../../../services/auth_service.dart';
import '../../../utils/snackbar.dart';

class CommentController extends GetxController {
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

  void clean() {
    commentList.clear();
    comment = "";
  }

  void getCommentsByReelId(int reelId) async {
    loading = true;
    try {
      commentList = await _commentRepo.getCommentByReelId(reelId, token!);
      printInfo(info: "commentList: $commentList");
    } catch (e) {
      print("getCommentsByReelId: $e");
    }
    loading = false;
    update();
  }

  void toggleLike(int index) {
    commentList[index].isLiked = !commentList[index].isLiked;
    if (commentList[index].isLiked) {
      commentList[index].likeCount++;
    } else {
      commentList[index].likeCount--;
    }
    _commentRepo.toggleCommentLike(commentList[index].id, token!);
    update();
  }

  void deleteComment(int index) async {
    try {
      await _commentRepo.toggleCommentLike(commentList[index].id, token!);
      update();
    } catch (e) {
      log('Delete Comment: $e');
    }
  }

  void addCommentLocally(CommentModel commentModel) {
    _commentList.add(commentModel);
    update();
  }

  void addComment(int reelId, VoidCallback onDone) async {
    if (comment.isEmpty) {
      showSnackBar("Please add comment", color: Colors.red);
      return;
    }
    var map = {
      'comment': comment.trim(),
    };
    comment = "";
    try {
      final commentModel =
          await _commentRepo.addCommentToReelId(token!, map, reelId);
      addCommentLocally(commentModel);
      onDone();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("addComment: $e");
    }
  }
}
