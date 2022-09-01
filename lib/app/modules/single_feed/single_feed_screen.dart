// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:reel_ro/app/modules/homepage/widgets/comment_tile.dart';
import 'package:reel_ro/app/modules/single_feed/single_feed_controller.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../models/photo_model.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/giveaway_repository.dart';
import '../../../repositories/profile_repository.dart';
import '../../../utils/base.dart';
import '../../../utils/circle_animation.dart';
import '../../../utils/colors.dart';
import '../../../utils/video_player_item.dart';
import '../../../widgets/my_elevated_button.dart';
import '../WebView/webview.dart';
import '../entry_count/views/entry_count_view.dart';
import '../homepage/comment_screen.dart';
import '../homepage/profile_detail_screen.dart';
import '../search/search_screen.dart';

class SingleFeedScreen extends StatelessWidget {
  SingleFeedScreen(this.reels, this.currentIndex,
      {this.openComment = false, Key? key})
      : super(key: key);

  List<ReelModel>? reels;
  int currentIndex;
  bool openComment;
  final _controller = Get.put(SingleFeedController());
  final _reelRepo = Get.put(ReelRepository());
  final _commentRepo = Get.put(CommentRepository());
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _profileRepo = Get.put(ProfileRepository());
  void openCommentSheet() {
    if (openComment) {
      Get.bottomSheet(
        CommentSheet(
          () {
            _controller.update();
          },
          reelId: reels![currentIndex].id,
        ),
        backgroundColor: Colors.white,
      );
      openComment = false;
    }
  }

  void initState() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    var parser = EmojiParser();
    WidgetsBinding.instance.addPostFrameCallback((_) => openCommentSheet());
    return GetBuilder<SingleFeedController>(
        builder: (_) => SafeArea(
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Get.back();
                      }),
                  title: const Center(child: Text("Your Rolls")),
                ),
                body: _controller.loading
                    ? Loading()
                    : PageView.builder(
                        allowImplicitScrolling: true,
                        itemCount: reels!.length,
                        controller: PageController(
                          initialPage: currentIndex,
                          viewportFraction: 1,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var isReel = true;
                          var videoSplit = reels![index].filename.split("_");
                          var videoUrl =
                              "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${reels![index].filename}/MP4/${reels![index].filename}";
                          if (videoSplit[0].contains('ads')) {
                            isReel = false;
                          }
                          return Stack(
                            children: [
                              VideoPlayerItem(
                                videoUrl: videoUrl,
                                videoId: reels![index].id,
                                isReel: true,
                                updatePoints: () {},
                                doubleTap: () {
                                  _controller.likeToggle(reels![index].id);
                                },
                                swipeRight: () {},
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
                                                left: 20, bottom: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                isReel
                                                    ? Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                if (_controller
                                                                        .profileId !=
                                                                    reels![index]
                                                                        .user
                                                                        .id) {
                                                                  Get.to(
                                                                    () => ProfileDetail(
                                                                        profileModel: reels![index].user,
                                                                        onBack: () {
                                                                          Get.back();
                                                                        }),
                                                                  );
                                                                }
                                                              },
                                                              child: Text(
                                                                "@${reels![index].user.username}",
                                                                style: style
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )),
                                                          _controller.profileId ==
                                                                  reels![index]
                                                                      .user
                                                                      .id
                                                              ? SizedBox()
                                                              : isReel
                                                                  ? FutureBuilder<
                                                                          bool>(
                                                                      future: _profileRepo.isFollowing(
                                                                          reels![index]
                                                                              .user
                                                                              .id,
                                                                          _controller
                                                                              .token!),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Container();
                                                                        }
                                                                        return TextButton(
                                                                          child: snapshot.data!
                                                                              ? Text("Following", style: TextStyle(color: Colors.white, fontSize: 12))
                                                                              : Text("Follow", style: TextStyle(color: Colors.white, fontSize: 12)),
                                                                          onPressed:
                                                                              () {
                                                                            Get.dialog(AlertDialog(
                                                                              backgroundColor: Colors.black54,
                                                                              title: snapshot.data!
                                                                                  ? Text(
                                                                                      "Do you wish to unfollow?",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    )
                                                                                  : Text(
                                                                                      "Do you wish to follow?",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                              actionsAlignment: MainAxisAlignment.spaceAround,
                                                                              actions: [
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: const Text("Cancel")),
                                                                                MaterialButton(
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                    _controller.toggleFollowing(reels![index].user.id);
                                                                                  },
                                                                                  child: const Text("Confirm"),
                                                                                  color: AppColors.buttonColor,
                                                                                ),
                                                                              ],
                                                                            ));
                                                                          },
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all(RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10.0))),
                                                                          ),
                                                                        );
                                                                      })
                                                                  : SizedBox(),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          Text(
                                                            "@sponsored",
                                                            style: style
                                                                .titleLarge!
                                                                .copyWith(
                                                              color:
                                                                  Colors.pink,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 150,
                                                            child:
                                                                MyElevatedButton(
                                                              buttonText:
                                                                  "Click Here",
                                                              height: 30,
                                                              style: style
                                                                  .titleMedium,
                                                              onPressed: () {
                                                                // if (data.url !=
                                                                //     "") {
                                                                Get.to(WebViewScreen(
                                                                    // data.url
                                                                    'https://flutter.dev'));
                                                                // }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                Text(
                                                  parser.emojify(reels![index]
                                                      .video_title),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                isReel
                                                    ? HashTagText(
                                                        onTap: (tag) {
                                                          Get.to(SearchHashTags(
                                                            hashTag: tag,
                                                          ));
                                                        },
                                                        text: parser.emojify(
                                                            reels![index]
                                                                .description),
                                                        basicStyle:
                                                            const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                        ),
                                                        decoratedStyle:
                                                            const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                        ))
                                                    : SizedBox(),

                                                // Text(
                                                //   parser.emojify(reels![index]
                                                //       .video_title),
                                                //   style: const TextStyle(
                                                //     fontSize: 20,
                                                //     color: Colors.white,
                                                //     fontWeight: FontWeight.bold,
                                                //   ),
                                                // ),
                                                // HashTagText(
                                                //   onTap: (tag) {
                                                //     print('5151' + tag);
                                                //     Get.to(SearchHashTags(
                                                //       hashTag: tag,
                                                //     ));
                                                //   },
                                                //   text: parser.emojify(
                                                //       reels![index]
                                                //           .description),
                                                //   basicStyle: const TextStyle(
                                                //     fontSize: 15,
                                                //     color: Colors.white,
                                                //   ),
                                                //   decoratedStyle:
                                                //       const TextStyle(
                                                //     fontSize: 15,
                                                //     color: Colors.blue,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 50,
                                          margin: isReel
                                              ? EdgeInsets.only(bottom: 15)
                                              : EdgeInsets.only(bottom: 50),
                                          child: isReel
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
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
                                                        // Text(
                                                        //   _controller
                                                        //       .totalEntryPoints
                                                        //       .value,
                                                        //   style: style
                                                        //       .headlineSmall!
                                                        //       .copyWith(
                                                        //     fontSize: 18,
                                                        //     color: Colors
                                                        //         .white,
                                                        //   ),
                                                        // ),
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
                                                                return Text(
                                                                  "0",
                                                                  style: style
                                                                      .headlineSmall!
                                                                      .copyWith(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white,
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
                                                    SizedBox(height: 15),
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
                                                                    reels![index]
                                                                        .id,
                                                                    _controller
                                                                        .token!),
                                                                builder:
                                                                    (context,
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
                                                                    reels![index]
                                                                        .id,
                                                                    _controller
                                                                        .token!),
                                                            builder: (context,
                                                                snap) {
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
                                                    SizedBox(height: 15),
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.bottomSheet(
                                                              CommentSheet(
                                                                () {
                                                                  _controller
                                                                      .update();
                                                                },
                                                                reelId: reels![
                                                                        index]
                                                                    .id,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                            );
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
                                                                    reels![index]
                                                                        .id,
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
                                                    SizedBox(height: 15),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.reply,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        // _changeRotation();
                                                        Get.to(
                                                            EntryCountView());
                                                      },
                                                      child: const Icon(
                                                        Icons.card_giftcard,
                                                        size: 30,
                                                        color: Colors.pink,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   _controller
                                                    //       .totalEntryPoints
                                                    //       .value,
                                                    //   style: style
                                                    //       .headlineSmall!
                                                    //       .copyWith(
                                                    //     fontSize: 18,
                                                    //     color: Colors
                                                    //         .white,
                                                    //   ),
                                                    // ),
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
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        })
                                                  ],
                                                ),

                                          // Column(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceEvenly,
                                          //   children: [
                                          //     Column(
                                          //       children: [
                                          //         InkWell(
                                          //           onTap: () {
                                          //             Get.to(EntryCountView());
                                          //           },
                                          //           child: const Icon(
                                          //             Icons.card_giftcard,
                                          //             size: 30,
                                          //             color: Colors.white,
                                          //           ),
                                          //         ),
                                          //         FutureBuilder<String>(
                                          //             future: _giveawayRepo
                                          //                 .getTotalEntryCountByUserId(
                                          //                     _controller
                                          //                         .profileId!,
                                          //                     _controller
                                          //                         .token!),
                                          //             builder:
                                          //                 (context, snapshot) {
                                          //               if (!snapshot.hasData) {
                                          //                 return Text(
                                          //                   "0",
                                          //                   style: style
                                          //                       .headlineSmall!
                                          //                       .copyWith(
                                          //                     fontSize: 18,
                                          //                     color:
                                          //                         Colors.white,
                                          //                   ),
                                          //                 );
                                          //               }
                                          //               if (snapshot.hasError) {
                                          //                 printInfo(
                                          //                     info:
                                          //                         "getTotalEntryCountByUserId: ${snapshot.hasError}");
                                          //                 return Container();
                                          //               }
                                          //               return Text(
                                          //                 snapshot.data
                                          //                     .toString(),
                                          //                 style: style
                                          //                     .headlineSmall!
                                          //                     .copyWith(
                                          //                   fontSize: 18,
                                          //                   color: Colors.white,
                                          //                 ),
                                          //               );
                                          //             })
                                          //       ],
                                          //     ),
                                          //     Column(
                                          //       children: [
                                          //         InkWell(
                                          //             onTap: () {
                                          //               _controller.likeToggle(
                                          //                   reels![index].id);
                                          //             },
                                          //             // _controller.likeVideo(data.id),
                                          //             child: FutureBuilder<
                                          //                     bool>(
                                          //                 future: _reelRepo
                                          //                     .getLikeFlag(
                                          //                         reels![index]
                                          //                             .id,
                                          //                         _controller
                                          //                             .token!),
                                          //                 builder:
                                          //                     (context, snap) {
                                          //                   return Icon(
                                          //                     snap.hasData
                                          //                         ? snap.data!
                                          //                             ? Icons
                                          //                                 .favorite
                                          //                             : Icons
                                          //                                 .favorite_border
                                          //                         : Icons
                                          //                             .favorite_border,
                                          //                     size: 30,
                                          //                     color: snap
                                          //                             .hasData
                                          //                         ? snap.data!
                                          //                             ? Colors
                                          //                                 .red
                                          //                             : Colors
                                          //                                 .white
                                          //                         : Colors
                                          //                             .white,
                                          //                   );
                                          //                 })),

                                          //         // const SizedBox(height: 7),
                                          //         FutureBuilder<int>(
                                          //             future: _reelRepo
                                          //                 .getLikeCountByReelId(
                                          //                     reels![index].id,
                                          //                     _controller
                                          //                         .token!),
                                          //             builder: (context, snap) {
                                          //               return Text(
                                          //                 snap.hasData
                                          //                     ? snap.data!
                                          //                         .toString()
                                          //                     : '0',
                                          //                 // data.likeCount.toString(),
                                          //                 style: style
                                          //                     .headlineSmall!
                                          //                     .copyWith(
                                          //                   fontSize: 18,
                                          //                   color: Colors.white,
                                          //                 ),
                                          //               );
                                          //             }),
                                          //       ],
                                          //     ),
                                          //     Column(
                                          //       children: [
                                          //         InkWell(
                                          //           onTap: () {
                                          //             Get.bottomSheet(
                                          //               CommentSheet(
                                          //                 reelId:
                                          //                     reels![index].id,
                                          //               ),
                                          //               backgroundColor:
                                          //                   Colors.white,
                                          //             );
                                          //           },
                                          //           child: const Icon(
                                          //             Icons.comment,
                                          //             size: 30,
                                          //             color: Colors.white,
                                          //           ),
                                          //         ),
                                          //         FutureBuilder<int>(
                                          //             future: _commentRepo
                                          //                 .getCommentCountByReelId(
                                          //                     reels![index].id,
                                          //                     _controller
                                          //                         .token!),
                                          //             builder:
                                          //                 (context, snapshot) {
                                          //               return Text(
                                          //                 snapshot.hasData
                                          //                     ? snapshot.data!
                                          //                         .toString()
                                          //                     : '0',
                                          //                 style: style
                                          //                     .headlineSmall!
                                          //                     .copyWith(
                                          //                   fontSize: 18,
                                          //                   color: Colors.white,
                                          //                 ),
                                          //               );
                                          //             })
                                          //       ],
                                          //     ),
                                          //     Column(
                                          //       children: [
                                          //         InkWell(
                                          //           onTap: () {},
                                          //           child: const Icon(
                                          //             Icons.reply,
                                          //             size: 30,
                                          //             color: Colors.white,
                                          //           ),
                                          //         ),
                                          //         // const SizedBox(height: 7),
                                          //         // Text(
                                          //         //   '0',
                                          //         //   style: const TextStyle(
                                          //         //     fontSize: 20,
                                          //         //     color: Colors.white,
                                          //         //   ),
                                          //         // )
                                          //       ],
                                          //     ),
                                          //   ],
                                          // ),
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
