import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/homepage/widgets/comment_tile.dart';

import '../../../models/comment_model.dart';
import '../../../repositories/reel_repository.dart';
import '../../../utils/empty_widget.dart';
import '../../../widgets/loading.dart';
import 'comment_controller.dart';

class CommentSheet extends StatelessWidget {
  final String reelId;
  CommentSheet({Key? key, required this.reelId}) : super(key: key);

  buildProfile(String profilePhoto) {
    return const CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(
        "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
      ),
    );
  }

  final _reelRepo = Get.put(ReelRepository());
  final _formKey = GlobalKey<FormState>();
  final _commentTextController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(CommentController());
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.getCommentsByReelId(reelId);
    });
    // _controller.customeInit();
    return GetBuilder<CommentController>(
      builder: (_) => FutureBuilder<List<CommentModel>>(
          future: _reelRepo.getCommentByReelId(
              int.parse(reelId), _controller.token!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            if (snapshot.hasError) {
              printInfo(info: "getCommentByReelId: ${snapshot.hasError}");
              return Container();
            }
            if (_controller.commentList.isNotEmpty) {
              snapshot.data!.addAll(_controller.commentList);
              _controller.commentList.clear();
            }
            return Column(
              children: [
                ListTile(
                  leading: Text('${snapshot.data!.length} Comments',
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
                        if (snapshot.data!.isEmpty)
                          const EmptyWidget("No comments available!")
                        else
                          ...List.generate(
                            snapshot.data!.length,
                            (index) => ListTile(
                              leading: buildProfile(""),
                              title: CommentWidget(
                                commentModel: snapshot.data![index],
                                likeToggle: () {
                                  _controller.toggleLike(index);
                                },
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
                      child: buildProfile(""),
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
                            _controller.comment = v!;
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
                            _controller.addComment(reelId, () {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                            });
                          }
                        },
                        icon: Icon(Icons.send),
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


// class CommentScreen extends StatelessWidget {
//   final String id;
//   CommentScreen({
//     Key? key,
//     required this.id,
//   }) : super(key: key);

//   final TextEditingController _commentController = TextEditingController();

//   final _controller = Get.put(HomePageController());

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SizedBox(
//           width: size.width,
//           height: size.height,
//           child: Column(
//             children: [
//               Expanded(
//                   child: ListView.builder(
//                       itemCount: 1,
//                       itemBuilder: (context, index) {
//                         final comment = _controller.comments[index];
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Colors.black,
//                             backgroundImage: NetworkImage(comment.profilePhoto),
//                           ),
//                           title: Row(
//                             children: [
//                               Text(
//                                 "${comment.username}  ",
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               Text(
//                                 comment.comment,
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           subtitle: Row(
//                             children: [
//                               Text(
//                                 comment.datePublished.toString(),
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 '${comment.likes.length} likes',
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             ],
//                           ),
//                           trailing: InkWell(
//                             onTap: () {},
//                             child: Icon(
//                               Icons.favorite,
//                               size: 25,
//                               color: Colors.red,
//                             ),
//                           ),
//                         );
//                       })),
//               const Divider(),
//               ListTile(
//                 title: TextFormField(
//                   controller: _commentController,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                   decoration: const InputDecoration(
//                     labelText: 'Comment',
//                     labelStyle: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.red,
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),
//                 ),
//                 trailing: TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'Send',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
