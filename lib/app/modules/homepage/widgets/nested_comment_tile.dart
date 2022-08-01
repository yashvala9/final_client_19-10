import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/widgets/loading.dart';

class NestedCommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  final VoidCallback likeToggle;
  final VoidCallback deleteCallBack;
  final ProfileModel profileModel;
  NestedCommentWidget(
      {Key? key,
      required this.commentModel,
      required this.likeToggle,
      required this.deleteCallBack,
      required this.profileModel})
      : super(key: key);

  final _profileRepo = Get.find<ProfileRepository>();
  final _authService = Get.find<AuthService>();

  bool showNestedComment = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onLongPress: () {
          if (commentModel.user.id == _authService.profileModel!.id) {
            deleteCallBack();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '@${profileModel.username}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '1 day ago',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  commentModel.comment,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          log("CommentId: $commentModel");
                          likeToggle();
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )),
                    Text(commentModel.likeCount.toString()),
                  ],
                )
              ],
            ),
            // StatefulBuilder(builder: (context, setState) {
            //   if (!showNestedComment) {
            //     return InkWell(
            //         onTap: () {},
            //         child: Text(
            //           '${commentModel.responseCount} Responses',
            //           style: const TextStyle(color: Colors.blue),
            //         ));
            //   } else {
            //     return FutureBuilder(builder: (context, snapshot) {
            //       return Container();
            //     });
            //   }
            // }),
          ],
        ),
      ),
    );
  }
}
