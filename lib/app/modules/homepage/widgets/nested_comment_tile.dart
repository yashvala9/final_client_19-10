import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/nessted_comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/datetime_extension.dart';
import 'package:reel_ro/widgets/loading.dart';

class NestedCommentWidget extends StatelessWidget {
  final NestedCommentModel nestedCommentModel;
  final VoidCallback likeToggle;
  final VoidCallback deleteCallBack;
  NestedCommentWidget({
    Key? key,
    required this.nestedCommentModel,
    required this.likeToggle,
    required this.deleteCallBack,
  }) : super(key: key);

  final _profileRepo = Get.find<ProfileRepository>();
  final _authService = Get.find<AuthService>();
  var parser = EmojiParser();

  bool showNestedComment = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
        left: 16,
        top: 4,
        bottom: 4,
      ),
      child: InkWell(
        onLongPress: () {
          if (nestedCommentModel.owner.id == _authService.profileModel!.id) {
            deleteCallBack();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '@${nestedCommentModel.owner.username}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  nestedCommentModel.createdAt.timeAgo(numericDates: false),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  parser.emojify(nestedCommentModel.response),
                ),
                Container(),
                // Row(
                //   children: [
                //     IconButton(
                //         onPressed: () {
                //           log("CommentId: $nestedCommentModel");
                //           likeToggle();
                //         },
                //         icon: const Icon(
                //           Icons.favorite,
                //           color: Colors.red,
                //         )),
                //     Text(nest.likeCount.toString()),
                //   ],
                // )
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
