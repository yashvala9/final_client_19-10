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
import '../../../utils/base.dart';
import '../../../utils/circle_animation.dart';
import '../../../utils/video_player_item.dart';
import '../entry_count/views/entry_count_view.dart';
import '../homepage/comment_screen.dart';
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
  void openCommentSheet() {
    Get.bottomSheet(
      CommentSheet(
        reelId: reels![currentIndex].id,
      ),
      backgroundColor: Colors.white,
    );
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => openCommentSheet());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    var parser = EmojiParser();
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
                        itemCount: reels!.length,
                        controller: PageController(
                            initialPage: currentIndex, viewportFraction: 1),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var videoSplit = reels![index].filename.split("_");
                          var videoUrl =
                              "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${reels![index].filename}/MP4/${reels![index].filename}";
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
                                                left: 20, bottom: 12),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  parser.emojify(reels![index]
                                                      .video_title),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                HashTagText(
                                                  onTap: (tag) {
                                                    print('5151' + tag);
                                                    Get.to(SearchHashTags(
                                                      hashTag: tag,
                                                    ));
                                                  },
                                                  text: parser.emojify(
                                                      reels![index]
                                                          .description),
                                                  basicStyle: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                  decoratedStyle:
                                                      const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          margin: EdgeInsets.only(
                                              top: size.height / 3),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(EntryCountView());
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
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Text(
                                                            "0",
                                                            style: style
                                                                .headlineSmall!
                                                                .copyWith(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        }
                                                        if (snapshot.hasError) {
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
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      })
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        _controller.likeToggle(
                                                            reels![index].id);
                                                      },
                                                      // _controller.likeVideo(data.id),
                                                      child: FutureBuilder<
                                                              bool>(
                                                          future: _reelRepo
                                                              .getLikeFlag(
                                                                  reels![index]
                                                                      .id,
                                                                  _controller
                                                                      .token!),
                                                          builder:
                                                              (context, snap) {
                                                            return Icon(
                                                              snap.hasData
                                                                  ? snap.data!
                                                                      ? Icons
                                                                          .favorite
                                                                      : Icons
                                                                          .favorite_border
                                                                  : Icons
                                                                      .favorite_border,
                                                              size: 30,
                                                              color: snap
                                                                      .hasData
                                                                  ? snap.data!
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
                                                              reels![index].id,
                                                              _controller
                                                                  .token!),
                                                      builder: (context, snap) {
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
                                                            color: Colors.white,
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
                                                              reels![index].id,
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
                                                              reels![index].id,
                                                              _controller
                                                                  .token!),
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          snapshot.hasData
                                                              ? snapshot.data!
                                                                  .toString()
                                                              : '0',
                                                          style: style
                                                              .headlineSmall!
                                                              .copyWith(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      })
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
