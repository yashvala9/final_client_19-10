import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/homepage/profile_detail_screen.dart';
import 'package:reel_ro/models/nessted_comment_model.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/datetime_extension.dart';

import '../../profile/profile_screen.dart';

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

  final _authService = Get.find<AuthService>();
  final parser = EmojiParser();

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
                InkWell(
                  onTap: () {
                    if (_authService.profileModel!.id !=
                        nestedCommentModel.owner.id) {
                      Get.to(
                        () => ProfileDetail(
                            profileModel: nestedCommentModel.owner,
                            onBack: () {
                              Get.back();
                            }),
                      );
                    } else {
                      Get.to(() => ProfileScreen());
                    }
                  },
                  child: Text(
                    '@${nestedCommentModel.owner.username}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                Expanded(
                  child: Text(
                    parser.emojify(nestedCommentModel.response),
                  ),
                ),
                Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
