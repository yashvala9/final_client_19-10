import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/widgets/loading.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  final VoidCallback likeToggle;
  CommentWidget(
      {Key? key, required this.commentModel, required this.likeToggle})
      : super(key: key);

  final _profileRepo = Get.find<ProfileRepository>();
  final _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    var profile = commentModel.user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '@${profile.username}',
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
                      likeToggle();
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )),
                Text('#'),
                // "commentModel.likeCount.toString()"),
              ],
            )
          ],
        ),
        // InkWell(
        //     onTap: () {},
        //     child: const Text(
        //       '2 Responses',
        //       style: TextStyle(color: Colors.blue),
        //     )),
      ],
    );
  }
}
