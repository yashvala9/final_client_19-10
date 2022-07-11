import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/comment_model.dart';
import '../../../repositories/comment_repository.dart';
import '../../../services/auth_service.dart';
import '../../../utils/snackbar.dart';

class CommentController extends GetxController {
  final _commentRepo = Get.put(CommentRepository());
  final _authService = Get.put(AuthService());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

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

  void getCommentsByReelId(String reelId) async {
    loading = true;
    try {
      commentList =
          await _commentRepo.getCommentByReelId(reelId, profileId!, token!);
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
    _commentRepo.toggleCommentLike(commentList[index].id, profileId!, token!);
    update();
  }

  void addCommentLocally(Map<String, dynamic> data, String reelId) {
    var comment = CommentModel(
        id: 0,
        comment: data['comment'],
        likeCount: 0,
        responseCount: 0,
        profile: profileId!,
        isLiked: false,
        reelId: reelId);
    _commentList.add(comment);
    update();
  }

  void addComment(String reelId, VoidCallback onDone) async {
    if (comment.isEmpty) {
      showSnackBar("Please add comment", color: Colors.red);
      return;
    }
    var map = {
      'userId': profileId,
      'reelId': reelId,
      'comment': comment.trim(),
    };
    comment = "";
    addCommentLocally(map, reelId);
    try {
      final message = await _commentRepo.addCommentToReelId(token!, map);
      onDone();
      print("addCommentSuccess: $message");
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("addComment: $e");
    }
  }
}
