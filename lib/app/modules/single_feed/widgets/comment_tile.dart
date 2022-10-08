import 'package:flutter/material.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  final ProfileModel profileModel;
  const CommentWidget(
      {Key? key, required this.commentModel, required this.profileModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )),
                Text(commentModel.likeCount.toString()),
              ],
            )
          ],
        ),
      ],
    );
  }
}
