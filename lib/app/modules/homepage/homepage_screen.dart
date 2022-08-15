// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/add_feed/add_feed_screen.dart';
import 'package:reel_ro/app/modules/homepage/homepage_controller.dart';
import 'package:reel_ro/app/modules/profile/other_profile_detail.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../repositories/giveaway_repository.dart';
import '../../../repositories/profile_repository.dart';
import '../../../utils/base.dart';
import '../../../utils/circle_animation.dart';
import '../../../utils/colors.dart';
import '../../../utils/video_player_item.dart';
import '../../../widgets/my_elevated_button.dart';
import '../add_feed/widgets/video_trimmer_view.dart';
import '../entry_count/views/entry_count_view.dart';
import '../search/search_screen.dart';
import 'comment_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'profile_detail_screen.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  final _reelRepo = Get.put(ReelRepository());
  final _profileRepo = Get.put(ProfileRepository());
  final _controller = Get.put(HomePageController());
  final _commentRepo = Get.put(CommentRepository());
  final _giveawayRepo = Get.put(GiveawayRepository());
  var myMenuItems = <String>[
    'Report',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Report':
        print('Report clicked');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    var parser = EmojiParser();
    return GetBuilder<HomePageController>(
        builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                              leading: Icon(Icons.video_camera_back),
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
                          // var video = await ImagePicker()
                          //     .pickVideo(source: ImageSource.gallery);
                          // if (video != null) {
                          //   Get.to(
                          //     () => AddFeedScreen(
                          //       file: File(video.path),
                          //       type: 0,
                          //     ),
                          //   );
                          // }
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
              //   actions: [
              //     IconButton(
              //         icon: const Icon(
              //           Icons.notifications_none,
              //         ),
              //         onPressed: () {}),
              //     IconButton(
              //       icon: const Icon(
              //         Icons.add_box_outlined,
              //       ),
              //       onPressed: () async {
              //         var video = await ImagePicker()
              //             .pickVideo(source: ImageSource.gallery);
              //         if (video != null) {
              //           Navigator.of(context).push(
              //             MaterialPageRoute(builder: (context) {
              //               return VideoTrimmerView(File(video.path));
              //             }),
              //           );
              //           // Get.to(
              //           //   () => AddFeedScreen(
              //           //     file: File(video.path),
              //           //     type: 0,
              //           //   ),
              //           // );
              //         }
              //       },
              //     ),
              //   ],
              // ),
              body: _controller.loading
                  ? Loading()
                  : _controller.reelList.isEmpty
                      ? EmptyWidget("No reels available!")
                      : RefreshIndicator(
                          onRefresh: () {
                            _controller.getFeeds();
                            return Future.value();
                          },
                          child: PageView.builder(
                            itemCount: _controller.reelList.length,
                            controller: PageController(
                                initialPage: 0, viewportFraction: 1),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              var isReel = true;
                              if (index == (_controller.reelList.length - 3) &&
                                  !_controller.loadingMore) {
                                _controller.getMoreFeed();
                              }
                              final data = _controller.reelList[index];
                              printInfo(info: "Data: ${data.toJson()}");

                              var videoSplit = data.filename.split("_");
                              var videoUrl =
                                  "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${data.filename}/MP4/${data.filename}";
                              if (videoSplit[0].contains('ads')) {
                                isReel = false;
                              }
                              // var url = data.filepath + data.filename;
                              // log("URL: $url");
                              // log("VideoURl: ${"https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${data.filename}/MP4/${data.filename}"}");
                              return Stack(
                                children: [
                                  VideoPlayerItem(
                                    videoUrl: videoUrl,
                                    videoId: data.id,
                                    isReel: isReel,
                                    // "https://d2qwvdd0y3hlmq.cloudfront.net/reel/10/20220801/reel_10_20220801_1659347680729_video-10.mp4/HLS/reel_10_20220801_1659347680729_video-10_720.m3u8",
                                    doubleTap: () {
                                      if (isReel) _controller.likeToggle(index);
                                    },
                                    swipeRight: () {
                                      if (isReel) {
                                        Get.to(
                                          () => ProfileDetail(
                                              profileModel: data.user),
                                        );
                                      }
                                    },
                                    showLike: _controller.showLike,
                                  ),
                                  // VideoPlayerWidget(
                                  //   url:
                                  //       "https://d2qwvdd0y3hlmq.cloudfront.net/reel/10/20220801/reel_10_20220801_1659347680729_video-10.mp4/HLS/reel_10_20220801_1659347680729_video-10_720.m3u8",
                                  //   doubleTap: () {
                                  //     _controller.likeToggle(index);
                                  //   },
                                  //   showLike: _controller.showLike,
                                  // ),

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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                          () => ProfileDetail(
                                                              profileModel:
                                                                  data.user),
                                                        );
                                                      },
                                                      child: isReel
                                                          ? Text(
                                                              "@${data.user.username}",
                                                              style: style
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : Text(
                                                              "@sponsored",
                                                              style: style
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                    ),
                                                    isReel
                                                        ? FutureBuilder<bool>(
                                                            future: _profileRepo
                                                                .isFollowing(
                                                                    data.user
                                                                        .id,
                                                                    _controller
                                                                        .token!),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Container();
                                                              }
                                                              return TextButton(
                                                                child: snapshot
                                                                        .data!
                                                                    ? Text(
                                                                        "Following",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15))
                                                                    : Text(
                                                                        "Follow",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold)),
                                                                onPressed: () {
                                                                  _controller
                                                                      .toggleFollowing(data
                                                                          .user
                                                                          .id);
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0))),
                                                                ),
                                                              );
                                                            })
                                                        : SizedBox(),
                                                    Text(
                                                      parser.emojify(
                                                          data.video_title),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    HashTagText(
                                                        onTap: (tag) {
                                                          Get.to(SearchHashTags(
                                                            hashTag: tag,
                                                          ));
                                                        },
                                                        text: parser.emojify(
                                                            data.description),
                                                        basicStyle:
                                                            const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                        ),
                                                        decoratedStyle:
                                                            const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              margin: EdgeInsets.only(
                                                  top: size.height / 5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(
                                                              EntryCountView());
                                                        },
                                                        child: const Icon(
                                                          Icons.card_giftcard,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      FutureBuilder<String>(
                                                          future: _giveawayRepo
                                                              .getTotalEntryCountByUserId(
                                                                  _controller
                                                                      .profileId!,
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
                                                                      "getTotalEntryCountByUserId: ${snapshot.hasError}");
                                                              return Container();
                                                            }
                                                            return Text(
                                                              snapshot.data
                                                                  .toString(),
                                                              style: style
                                                                  .headlineSmall!
                                                                  .copyWith(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          })
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            if (isReel) {
                                                              _controller
                                                                  .likeToggle(
                                                                      index);
                                                            }
                                                          },
                                                          // _controller.likeVideo(data.id),
                                                          child: FutureBuilder<
                                                                  bool>(
                                                              future: _reelRepo
                                                                  .getLikeFlag(
                                                                      data.id,
                                                                      _controller
                                                                          .token!),
                                                              builder: (context,
                                                                  snap) {
                                                                return Icon(
                                                                  snap.hasData
                                                                      ? snap
                                                                              .data!
                                                                          ? Icons
                                                                              .favorite
                                                                          : Icons
                                                                              .favorite_border
                                                                      : Icons
                                                                          .favorite_border,
                                                                  size: 30,
                                                                  color: snap
                                                                          .hasData
                                                                      ? snap
                                                                              .data!
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .white
                                                                      : Colors
                                                                          .white,
                                                                );
                                                              })),
                                                      // const SizedBox(height: 7),
                                                      FutureBuilder<int>(
                                                          future: _reelRepo
                                                              .getLikeCountByReelId(
                                                                  data.id,
                                                                  _controller
                                                                      .token!),
                                                          builder:
                                                              (context, snap) {
                                                            return Text(
                                                              snap.hasData
                                                                  ? snap.data!
                                                                      .toString()
                                                                  : '0',
                                                              // data.likeCount.toString(),
                                                              style: style
                                                                  .headlineSmall!
                                                                  .copyWith(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (isReel) {
                                                            Get.bottomSheet(
                                                              CommentSheet(
                                                                reelId: data.id,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                            );
                                                          }
                                                        },
                                                        child: const Icon(
                                                          Icons.comment,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      FutureBuilder<int>(
                                                          future: _commentRepo
                                                              .getCommentCountByReelId(
                                                                  data.id,
                                                                  _controller
                                                                      .token!),
                                                          builder: (context,
                                                              snapshot) {
                                                            return Text(
                                                              snapshot.hasData
                                                                  ? snapshot
                                                                      .data!
                                                                      .toString()
                                                                  : '0',
                                                              style: style
                                                                  .headlineSmall!
                                                                  .copyWith(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          })
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: const Icon(
                                                      Icons.reply,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  PopupMenuButton<String>(
                                                      child: const Icon(
                                                        Icons.more_vert,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                      onSelected: onSelect,
                                                      itemBuilder: (BuildContext
                                                          context) {
                                                        return myMenuItems.map(
                                                            (String choice) {
                                                          return PopupMenuItem<
                                                              String>(
                                                            child: Text(choice),
                                                            value: choice,
                                                          );
                                                        }).toList();
                                                      })
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
                        ),
            ));
  }
}
