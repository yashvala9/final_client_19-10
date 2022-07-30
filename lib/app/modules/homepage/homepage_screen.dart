// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/add_feed/add_feed_screen.dart';
import 'package:reel_ro/app/modules/homepage/homepage_controller.dart';
import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../repositories/reel_repository.dart';
import '../../../utils/circle_animation.dart';
import '../../../utils/colors.dart';
import '../../../utils/video_player_iten.dart';
import '../add_feed/widgets/video_trimmer_view.dart';
import 'comment_screen.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  final _reelRepo = Get.put(ReelRepository());
  final _controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return GetBuilder<HomePageController>(
        builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      _controller.signOut();
                    }),
                title: const Center(
                    child: Text(
                  "Rolls For You",
                )),
                actions: [
                  IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                      ),
                      onPressed: () {}),
                  IconButton(
                    icon: const Icon(
                      Icons.add_box_outlined,
                    ),
                    onPressed: () async {
                      final val = await showDialog(
                        context: context,
                        builder: (_) => Dialog(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              leading: Icon(Icons.video_call),
                              title: Text("Video"),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              leading: Icon(Icons.photo),
                              title: Text("Photo"),
                            ),
                          ],
                        )),
                      );
                      if (val != null) {
                        if (val) {
                          var video = await ImagePicker()
                              .pickVideo(source: ImageSource.gallery);
                          if (video != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return VideoTrimmerView(File(video.path));
                              }),
                            );
                          }
                        } else {
                          var photo = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (photo != null) {
                            Get.to(
                              () => AddFeedScreen(
                                file: File(photo.path),
                                type: 1,
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
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
                            printInfo(info: "Data: ${data.toJson()}");
                            return Stack(
                              children: [
                                VideoPlayerWidget(
                                  url:
                                      "https://reelro-vod-destinationbucket.s3.ap-south-1.amazonaws.com/reel/1/20220723/98989/reel_1_20220723_98989_file1.mp4/MP4/reel_1_20220723_98989_file1.mp4",
                                  doubleTap: () {
                                    _controller.likeToggle(index);
                                  },
                                  showLike: _controller.showLike,
                                ),
                                // data.type
                                //     ?
                                //  VideoPlayerItem(
                                //     videoUrl: data.video.url,
                                //     doubleTap: () {
                                //       _controller.likeToggle(index);
                                //     },
                                //     showLike: _controller.showLike,
                                //   ),
                                // : CachedNetworkImage(
                                //     imageUrl: data.video.url,
                                //     placeholder: (context, _) => Loading(),
                                //     errorWidget: (context, s, e) => Icon(
                                //       Icons.error,
                                //       color: Colors.red,
                                //     ),
                                //   ),
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
                                                    "@${data.user.username}",
                                                    style: style.titleLarge!
                                                        .copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    data.video_title,
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
                                                  // Row(
                                                  //   children: [
                                                  //     const Icon(
                                                  //       Icons.music_note,
                                                  //       size: 15,
                                                  //       color: Colors.white,
                                                  //     ),
                                                  //     Text(
                                                  //       'data.song',
                                                  //       style: const TextStyle(
                                                  //         fontSize: 15,
                                                  //         color: Colors.white,
                                                  //         fontWeight:
                                                  //             FontWeight.bold,
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // )
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
                                                      child: FutureBuilder<
                                                              bool>(
                                                          future: _reelRepo
                                                              .isReelLikedByCurrentUser(
                                                                  data.id,
                                                                  _controller
                                                                      .token!),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Loading();
                                                            }
                                                            if (snapshot
                                                                .hasError) {
                                                              printInfo(
                                                                  info:
                                                                      "isReelLikedByCurrentUser: ${snapshot.hasError}");
                                                              return Container();
                                                            }
                                                            return Icon(
                                                              snapshot.data!
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              size: 30,
                                                              color: snapshot
                                                                      .data!
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .white,
                                                            );
                                                          }),
                                                    ),
                                                    // const SizedBox(height: 7),
                                                    Text(
                                                      '20',
                                                      // data.likeCount.toString(),
                                                      style: style
                                                          .headlineSmall!
                                                          .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                //TODO need to replace it with comment count api
                                                FutureBuilder<
                                                        List<CommentModel>>(
                                                    future: _reelRepo
                                                        .getCommentByReelId(
                                                            data.id,
                                                            _controller.token!),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const Loading();
                                                      }
                                                      if (snapshot.hasError) {
                                                        printInfo(
                                                            info:
                                                                "getCommentByReelId: ${snapshot.hasError}");
                                                        return Container();
                                                      }
                                                      return Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Get.bottomSheet(
                                                                CommentSheet(
                                                                  reelId: data
                                                                      .id
                                                                      .toString(),
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.comment,
                                                              size: 30,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data!.length
                                                                .toString(),
                                                            style: style
                                                                .headlineSmall!
                                                                .copyWith(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }),
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
                                                      "https://firebasestorage.googleapis.com/v0/b/cucumia-369c1.appspot.com/o/images%2FMagazines%2F2022-06-17%2015%3A03%3A33.892_2022-06-17%2015%3A03%3A33.893.jpg?alt=media&token=75624798-52a6-4735-a422-092955a6aa3a"),
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
