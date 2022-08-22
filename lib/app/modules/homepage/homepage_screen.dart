// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/add_feed/add_feed_screen.dart';
import 'package:reel_ro/app/modules/homepage/homepage_controller.dart';
import 'package:reel_ro/app/modules/profile/profile_controller.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../repositories/giveaway_repository.dart';
import '../../../repositories/profile_repository.dart';
import '../../../utils/video_player_item.dart';
import '../../notification_screen.dart';
import '../add_feed/widgets/video_trimmer_view.dart';
import '../entry_count/views/entry_count_view.dart';
import '../search/search_screen.dart';
import 'comment_screen.dart';

import 'profile_detail_screen.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  final _reelRepo = Get.put(ReelRepository());
  final _profileRepo = Get.put(ProfileRepository());
  final _controller = Get.put(HomePageController());
  final _commentRepo = Get.put(CommentRepository());
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _profileController = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());
  var myMenuItems = <String>[
    'Report',
  ];

  void onSelect(int id, int index) {
    _controller.reportReelOrComment('reel', id, index);
    moveNextReel(index + 1);
  }

  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );

  void moveNextReel(int index) {
    pageController.jumpToPage(index);
    _controller.updateManually();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    var parser = EmojiParser();
    return GetBuilder<HomePageController>(
        builder: (_) => SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: const Center(
                      child: Text(
                    "Rolls For You",
                  )),
                  actions: [
                    IconButton(
                        icon: const Icon(
                          Icons.notifications_none,
                        ),
                        onPressed: () {
                          Get.to(NotificationScreen());
                        }),
                    IconButton(
                      icon: const Icon(
                        Icons.add_box_outlined,
                      ),
                      onPressed: () async {
                        // final val = await showDialog(
                        //   context: context,
                        //   builder: (_) => Dialog(
                        //       child: Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       ListTile(
                        //         onTap: () {
                        //           Navigator.pop(context, true);
                        //         },
                        //         leading: Icon(Icons.video_camera_back),
                        //         title: Text("Video"),
                        //       ),
                        //       ListTile(
                        //         onTap: () {
                        //           Navigator.pop(context, false);
                        //         },
                        //         leading: Icon(Icons.photo),
                        //         title: Text("Photo"),
                        //       ),
                        //     ],
                        //   )),
                        // );
                        // if (val != null) {
                        //   if (val) {
                        //     var video = await ImagePicker()
                        //         .pickVideo(source: ImageSource.gallery);
                        //     if (video != null) {
                        //       Navigator.of(context).push(
                        //         MaterialPageRoute(builder: (context) {
                        //           return VideoTrimmerView(File(video.path));
                        //         }),
                        //       );
                        //     }
                        //   } else {
                        //     var photo = await ImagePicker()
                        //         .pickImage(source: ImageSource.gallery);
                        //     if (photo != null) {
                        //       Get.to(
                        //         () => AddFeedScreen(
                        //           file: File(photo.path),
                        //           type: 1,
                        //         ),
                        //       );
                        //     }
                        //   }
                        // }
                        var video = await ImagePicker()
                            .pickVideo(source: ImageSource.gallery);
                        if (video != null) {
                          final val = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return VideoTrimmerView(File(video.path));
                            }),
                          );
                          if (val != null) {
                            log("VideoAdded: $val");
                            _profileController.updateManually();
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
                        : RefreshIndicator(
                            onRefresh: () {
                              _controller.getFeeds();
                              return Future.value();
                            },
                            child: PageView.builder(
                              itemCount: _controller.reelList.length,
                              controller: pageController,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var isReel = true;
                                if (index ==
                                        (_controller.reelList.length - 3) &&
                                    !_controller.loadingMore) {
                                  _controller.getMoreFeed();
                                }
                                final data = _controller.reelList[index];

                                var videoSplit = data.filename.split("_");
                                var videoUrl =
                                    "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${data.filename}/MP4/${data.filename}";
                                if (videoSplit[0].contains('ads')) {
                                  isReel = false;
                                }
                                return Stack(
                                  children: [
                                    VideoPlayerItem(
                                      videoUrl: videoUrl,
                                      videoId: data.id,
                                      isReel: isReel,
                                      doubleTap: () {
                                        if (isReel) {
                                          _controller.likeToggle(index);
                                        }
                                      },
                                      swipeRight: () {
                                        if (isReel) {
                                          if (_controller.profileId !=
                                              data.user.id) {
                                            Get.to(
                                              () => ProfileDetail(
                                                  profileModel: data.user),
                                            );
                                          }
                                        }
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, bottom: 12),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (_controller
                                                                  .profileId !=
                                                              data.user.id) {
                                                            Get.to(
                                                              () => ProfileDetail(
                                                                  profileModel:
                                                                      data.user),
                                                            );
                                                          }
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
                                                      _controller.profileId ==
                                                              data.user.id
                                                          ? SizedBox()
                                                          : isReel
                                                              ? FutureBuilder<
                                                                      bool>(
                                                                  future: _profileRepo.isFollowing(
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
                                                                              style: TextStyle(color: Colors.white, fontSize: 15))
                                                                          : Text("Follow", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                      onPressed:
                                                                          () {
                                                                        _controller.toggleFollowing(data
                                                                            .user
                                                                            .id);
                                                                      },
                                                                      style:
                                                                          ButtonStyle(
                                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                            side: BorderSide(
                                                                                color: Colors.white,
                                                                                width: 1,
                                                                                style: BorderStyle.solid),
                                                                            borderRadius: BorderRadius.circular(10.0))),
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
                                                            Get.to(
                                                                SearchHashTags(
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
                                                    top: size.height /
                                                        (isReel ? 3 : 2)),
                                                child: isReel
                                                    ? Column(
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
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .card_giftcard,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              FutureBuilder<
                                                                      String>(
                                                                  future: _giveawayRepo.getTotalEntryCountByUserId(
                                                                      _controller
                                                                          .profileId!,
                                                                      _controller
                                                                          .token!),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return Text(
                                                                        "0",
                                                                        style: style
                                                                            .headlineSmall!
                                                                            .copyWith(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      );
                                                                    }
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      printInfo(
                                                                          info:
                                                                              "getTotalEntryCountByUserId: ${snapshot.hasError}");
                                                                      return Container();
                                                                    }
                                                                    return Text(
                                                                      snapshot
                                                                          .data
                                                                          .toString(),
                                                                      style: style
                                                                          .headlineSmall!
                                                                          .copyWith(
                                                                        fontSize:
                                                                            18,
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
                                                                    _controller
                                                                        .likeToggle(
                                                                            index);
                                                                  },
                                                                  // _controller.likeVideo(data.id),
                                                                  child: FutureBuilder<
                                                                          bool>(
                                                                      future: _reelRepo.getLikeFlag(
                                                                          data
                                                                              .id,
                                                                          _controller
                                                                              .token!),
                                                                      builder:
                                                                          (context,
                                                                              snap) {
                                                                        return Icon(
                                                                          snap.hasData
                                                                              ? snap.data!
                                                                                  ? Icons.favorite
                                                                                  : Icons.favorite_border
                                                                              : Icons.favorite_border,
                                                                          size:
                                                                              30,
                                                                          color: snap.hasData
                                                                              ? snap.data!
                                                                                  ? Colors.red
                                                                                  : Colors.white
                                                                              : Colors.white,
                                                                        );
                                                                      })),
                                                              // const SizedBox(height: 7),
                                                              FutureBuilder<
                                                                      int>(
                                                                  future: _reelRepo.getLikeCountByReelId(
                                                                      data.id,
                                                                      _controller
                                                                          .token!),
                                                                  builder:
                                                                      (context,
                                                                          snap) {
                                                                    return Text(
                                                                      snap.hasData
                                                                          ? snap
                                                                              .data!
                                                                              .toString()
                                                                          : '0',
                                                                      // data.likeCount.toString(),
                                                                      style: style
                                                                          .headlineSmall!
                                                                          .copyWith(
                                                                        fontSize:
                                                                            18,
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
                                                                  Get.bottomSheet(
                                                                    CommentSheet(
                                                                      reelId:
                                                                          data.id,
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  );
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.comment,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              FutureBuilder<
                                                                      int>(
                                                                  future: _commentRepo.getCommentCountByReelId(
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
                                                                        fontSize:
                                                                            18,
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
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          PopupMenuButton<
                                                                  String>(
                                                              child: const Icon(
                                                                Icons.more_vert,
                                                                size: 30,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onSelected: (v) {
                                                                Get.dialog(
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      "Please provide the reason:"),
                                                                  content:
                                                                      TextFormField(),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child: const Text(
                                                                            "Cancel")),
                                                                    MaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                        onSelect(
                                                                            data.id,
                                                                            index);
                                                                        showSnackBar(
                                                                            'This reel has been reported to the Admin!');
                                                                      },
                                                                      child: const Text(
                                                                          "Report"),
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ],
                                                                ));
                                                              },
                                                              itemBuilder:
                                                                  (BuildContext
                                                                      context) {
                                                                return myMenuItems
                                                                    .map((String
                                                                        choice) {
                                                                  return PopupMenuItem<
                                                                      String>(
                                                                    child: Text(
                                                                        choice),
                                                                    value:
                                                                        choice,
                                                                  );
                                                                }).toList();
                                                              })
                                                        ],
                                                      )
                                                    : Column(
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
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .card_giftcard,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              FutureBuilder<
                                                                      String>(
                                                                  future: _giveawayRepo.getTotalEntryCountByUserId(
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
                                                                      snapshot
                                                                          .data
                                                                          .toString(),
                                                                      style: style
                                                                          .headlineSmall!
                                                                          .copyWith(
                                                                        fontSize:
                                                                            18,
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
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          PopupMenuButton<
                                                                  String>(
                                                              child: const Icon(
                                                                Icons.more_vert,
                                                                size: 30,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onSelected: (v) {
                                                                Get.dialog(
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      "Please provide the reason:"),
                                                                  content:
                                                                      TextFormField(),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child: const Text(
                                                                            "Cancel")),
                                                                    MaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                        onSelect(
                                                                            data.id,
                                                                            index);
                                                                        showSnackBar(
                                                                            'This reel has been reported to the Admin!');
                                                                      },
                                                                      child: const Text(
                                                                          "Report"),
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ],
                                                                ));
                                                              },
                                                              itemBuilder:
                                                                  (BuildContext
                                                                      context) {
                                                                return myMenuItems
                                                                    .map((String
                                                                        choice) {
                                                                  return PopupMenuItem<
                                                                      String>(
                                                                    child: Text(
                                                                        choice),
                                                                    value:
                                                                        choice,
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
              ),
            ));
  }
}
