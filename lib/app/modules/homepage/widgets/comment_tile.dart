import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/homepage/widgets/nested_comment_tile.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/nessted_comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/datetime_extension.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../../../utils/snackbar.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  final VoidCallback likeToggle;
  final VoidCallback deleteCallBack;
  final VoidCallback increaseNestedCountCallBack;
  final ProfileModel profileModel;
  final bool isPhoto;
  CommentWidget(
      {Key? key,
      required this.isPhoto,
      required this.commentModel,
      required this.likeToggle,
      required this.deleteCallBack,
      required this.increaseNestedCountCallBack,
      required this.profileModel})
      : super(key: key);

  final _authService = Get.find<AuthService>();
  final _commentRepo = Get.find<CommentRepository>();
  final parser = EmojiParser();

  @override
  Widget build(BuildContext context) {
    bool showNestedComment = false;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onLongPress: () {
          if (commentModel.user.id == _authService.profileModel!.id) {
            deleteCallBack();
          }
        },
        child: StatefulBuilder(builder: (context, setState) {
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
                  Text(
                    commentModel.createdAt.timeAgo(numericDates: false),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    parser.emojify(commentModel.comment),
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
                      Text(commentModel.likeCount.toString()),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  showNestedComment
                      ? Container()
                      : InkWell(
                          onTap: () {
                            setState(() {
                              showNestedComment = true;
                            });
                          },
                          child: Text(
                            '${commentModel.responseCount} Responses',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      var replyController = TextEditingController();
                      final val = await Get.dialog(Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Reply to @${commentModel.user.username}",
                                style: style.titleLarge,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: replyController,
                                decoration: InputDecoration(
                                  hintText:
                                      ' Add a comment to @${commentModel.user.username}',
                                ),
                                onSaved: (v) {},
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyElevatedButton(
                                buttonText: "Reply",
                                height: 30,
                                onPressed: () async {
                                  if (replyController.text.isNotEmpty) {
                                    try {
                                      await _commentRepo.addNestedComment(
                                        commentModel.id,
                                        parser.unemojify(replyController.text),
                                        _authService.token!,
                                        isPhoto: isPhoto,
                                      );
                                      replyController.text = "";
                                      Get.back(result: true);

                                      increaseNestedCountCallBack();
                                    } catch (e) {
                                      showSnackBar(e.toString(),
                                          color: Colors.red);
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ));
                      if (val != null) {
                        setState(() {
                          showNestedComment = showNestedComment;
                        });
                      }
                    },
                    child: const Text(
                      'Reply',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              if (showNestedComment)
                FutureBuilder<List<NestedCommentModel>>(
                    future: _commentRepo.getNestedCommentByCommentId(
                        commentModel.id, _authService.token!, isPhoto),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Loading();
                      }
                      var nestedComments = snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: nestedComments
                            .map(
                              (e) => NestedCommentWidget(
                                nestedCommentModel: e,
                                likeToggle: () {},
                                deleteCallBack: () {},
                              ),
                            )
                            .toList(),
                      );
                    }),
            ],
          );
        }),
      ),
    );
  }
}
