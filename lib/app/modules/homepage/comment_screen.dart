import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/homepage/widgets/comment_tile.dart';
import 'package:reel_ro/utils/snackbar.dart';

import '../../../models/comment_model.dart';
import '../../../repositories/comment_repository.dart';
import '../../../repositories/reel_repository.dart';
import '../../../utils/base.dart';
import '../../../utils/empty_widget.dart';
import '../../../widgets/loading.dart';
import 'comment_controller.dart';

class CommentSheet extends StatelessWidget {
  final int id;
  final bool isPhoto;
  final VoidCallback onCommentUpdated;

  CommentSheet(
    this.onCommentUpdated, {
    Key? key,
    required this.id,
    required this.isPhoto,
  }) : super(key: key);

  buildProfile(String profilePhoto) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(
        profilePhoto,
      ),
    );
  }

  final _reelRepo = Get.put(ReelRepository());
  final _formKey = GlobalKey<FormState>();
  final _commentTextController = TextEditingController();
  final _scrollController = ScrollController();
  var parser = EmojiParser();

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(CommentController());
    final _commentRepo = Get.put(CommentRepository());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.getCommentsById(id, isPhoto: isPhoto);
    });
    // _controller.customeInit();
    return GetBuilder<CommentController>(
      builder: (_) => FutureBuilder<List<CommentModel>>(
          future: _commentRepo.getCommentById(id, _controller.token!,
              isPhoto: isPhoto),
          builder: (context, snapshot) {
            if (_controller.loading) {
              return const Loading();
            }
            // if (snapshot.hasError) {
            //   printInfo(info: "getCommentByReelId: ${snapshot.hasError}");
            //   return Container();
            // }
            // if (_controller.commentList.isNotEmpty) {
            //   snapshot.data!.addAll(_controller.commentList);
            //   _controller.commentList.clear();
            // }
            return Column(
              children: [
                ListTile(
                  leading: Text('${_controller.commentList.length} Comments',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_controller.commentList.isEmpty)
                          const EmptyWidget("No comments available!")
                        else
                          ...List.generate(
                            _controller.commentList.length,
                            (index) => ListTile(
                              leading: buildProfile(
                                  "${Base.profileBucketUrl}/${_controller.commentList[index].user.user_profile!.profile_img}"),
                              title: CommentWidget(
                                commentModel: _controller.commentList[index],
                                likeToggle: () {
                                  _controller.toggleLike(index);
                                },
                                increaseNestedCountCallBack: () {
                                  _controller
                                      .commentList[index].responseCount++;
                                },
                                deleteCallBack: () {
                                  Get.dialog(AlertDialog(
                                    title: const Text(
                                        "Are you sure you want to delete this comment?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text("NO")),
                                      MaterialButton(
                                        onPressed: () {
                                          _controller.deleteComment(index);

                                          onCommentUpdated();
                                          Get.back();
                                        },
                                        child: const Text("YES"),
                                        color: Colors.red,
                                      ),
                                    ],
                                  ));
                                },
                                profileModel:
                                    _controller.commentList[index].user,
                              ),
                            ),
                          ).toList(),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: buildProfile(
                          "${Base.profileBucketUrl}/${_controller.profileModel.user_profile!.profile_img!}"),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _commentTextController,
                          decoration: const InputDecoration(
                            hintText: ' Add a comment',
                          ),
                          onSaved: (v) {
                            _controller.comment = parser.unemojify(v!);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _commentTextController.clear();
                            _controller.addComment(id, () {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                            });
                            onCommentUpdated();
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
