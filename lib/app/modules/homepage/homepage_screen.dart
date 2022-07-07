// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/add_feed/add_feed_screen.dart';
import 'package:reel_ro/app/modules/homepage/homepage_controller.dart';
import 'package:reel_ro/app/modules/homepage/widgets/comment_tile.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../utils/circle_animation.dart';
import '../../../utils/video_player_iten.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  final _controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return GetBuilder<HomePageController>(
        builder: (_) => Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
                title: const Center(child: Text("Rolls For You")),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.add_box_outlined),
                      onPressed: () async {
                        var video = await ImagePicker()
                            .pickVideo(source: ImageSource.gallery);
                        if (video != null) {
                          Get.to(() => AddFeedScreen(file: File(video.path)));
                        }
                      }),
                ],
              ),
              body: _controller.loading
                  ? Loading()
                  : _controller.reelList.isEmpty
                      ? EmptyWidget("No reels available!")
                      : PageView.builder(
                          itemCount: _controller.reelList.length,
                          controller: PageController(
                              initialPage: 0, viewportFraction: 1),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final data = _controller.reelList[index];
                            return Stack(
                              children: [
                                VideoPlayerItem(
                                  videoUrl: data.mediaLink,
                                  doubleTap: () {
                                    _controller.likeToggle(index);
                                  },
                                  showLike: _controller.showLike,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, bottom: 12),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    data.title,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    data.description,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.music_note,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        data.song,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            margin: EdgeInsets.only(
                                                top: size.height / 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      // _controller.likeVideo(data.id),
                                                      child: const Icon(
                                                        Icons.card_giftcard,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    // const SizedBox(height: 7),
                                                    Text(
                                                      '0',
                                                      style: style
                                                          .headlineSmall!
                                                          .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      // _controller.likeVideo(data.id),
                                                      child: Icon(
                                                        data.isLiked
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        size: 30,
                                                        color: data.isLiked
                                                            ? Colors.red
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                    // const SizedBox(height: 7),
                                                    Text(
                                                      data.likeCount.toString(),
                                                      style: style
                                                          .headlineSmall!
                                                          .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return CommentSheet(
                                                                reelId:
                                                                    data.reelId,
                                                              );
                                                            });
                                                      },
                                                      child: const Icon(
                                                        Icons.comment,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.reelComments.length
                                                          .toString(),
                                                      style: style
                                                          .headlineSmall!
                                                          .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.reply,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    // const SizedBox(height: 7),
                                                    // Text(
                                                    //   '0',
                                                    //   style: const TextStyle(
                                                    //     fontSize: 20,
                                                    //     color: Colors.white,
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                                CircleAnimation(
                                                  child: buildMusicAlbum(
                                                      data.profile.profileUrl),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
            ));
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: const Image(
                image: AssetImage(
                  "assets/Background.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }
}

class CommentSheet extends StatelessWidget {
  final String reelId;
  CommentSheet({Key? key, required this.reelId}) : super(key: key);

  buildProfile(String profilePhoto) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: const NetworkImage(
        "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(CommentController(reelId: reelId));
    // _controller.customeInit();
    return GetBuilder<CommentController>(
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _controller.loading
            ? [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Loading(),
                )
              ]
            : [
                ListTile(
                  leading: Text('${_controller.commentList.length} Comments',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Divider(),
                // ListTile(
                //   leading: buildProfile(""),
                //   title: Container(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             Text(
                //               '@yashvala9',
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             ),
                //             SizedBox(
                //               width: 10,
                //             ),
                //             Text(
                //               '1 day ago',
                //             ),
                //           ],
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Hey! check this out.',
                //             ),
                //             Row(
                //               children: [
                //                 IconButton(
                //                     onPressed: () {},
                //                     icon: Icon(
                //                       Icons.favorite,
                //                       color: Colors.red,
                //                     )),
                //                 Text('2'),
                //               ],
                //             )
                //           ],
                //         ),
                //         InkWell(
                //             onTap: () {},
                //             child: Text(
                //               '2 Responses',
                //               style: TextStyle(color: Colors.blue),
                //             )),
                //       ],
                //     ),
                //   ),
                // ),
                if (_controller.commentList.isEmpty)
                  EmptyWidget("No comments available!")
                else
                  ..._controller.commentList
                      .map(
                        (e) => ListTile(
                          leading: buildProfile(""),
                          title: CommentWidget(commentModel: e),
                        ),
                      )
                      .toList(),
                Divider(),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: buildProfile(""),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
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
                            _controller.addComment();
                          }
                        },
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ],
      ),
    );
  }
}
