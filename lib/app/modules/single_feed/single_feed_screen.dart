// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
import 'package:share_plus/share_plus.dart';
import '../../../models/photo_model.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/giveaway_repository.dart';
import '../../../repositories/profile_repository.dart';
import '../../../utils/base.dart';
import '../../../utils/colors.dart';
import '../../../utils/video_player_item.dart';
import '../../../widgets/my_elevated_button.dart';
import '../WebView/webview.dart';
import '../entry_count/views/entry_count_view.dart';
import '../homepage/comment_screen.dart';
import '../homepage/profile_detail_screen.dart';
import '../search/search_screen.dart';

class SingleFeedScreen extends StatelessWidget {
  SingleFeedScreen(this.photos, this.reels, this.currentIndex,
      {this.openComment = false, this.isPhoto = false, Key? key})
      : super(key: key);
  bool isPhoto;
  List<ReelModel>? reels;
  List<PhotoModel>? photos;
  int currentIndex;
  bool openComment;
  final _controller = Get.put(SingleFeedController());
  final _reelRepo = Get.put(ReelRepository());
  final _commentRepo = Get.put(CommentRepository());
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _profileRepo = Get.put(ProfileRepository());

  bool shareLoading = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<Uri> createDynamicLink(int id, String type) async {
    log("Type:: $type");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://reelro.page.link',
      link: Uri.parse('https://reelro.page.link/?id=$id/$type'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.reel_ro',
        minimumVersion: 1,
      ),
      // iosParameters: IOSParameters(
      //   bundleId: '',
      //   minimumVersion: 0
      // )
    );
    var dynamicUrl = await dynamicLinks.buildShortLink(parameters);
    final Uri shortUrl = dynamicUrl.shortUrl;
    log("link:: $shortUrl");
    return shortUrl;
  }

  void openCommentSheet() {
    if (openComment) {
      Get.bottomSheet(
        CommentSheet(
          () {
            _controller.update();
          },
          id: reels![currentIndex].id,
          isPhoto: isPhoto,
        ),
        backgroundColor: Colors.white,
      );
      openComment = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Get.mediaQuery.size;
    final theme = Get.theme;
    final style = theme.textTheme;
    var parser = EmojiParser();
    var isLiked = false;

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
                ),
                body: _controller.loading
                    ? Loading()
                    : PageView.builder(
                        allowImplicitScrolling: true,
                        itemCount: isPhoto ? photos!.length : reels!.length,
                        controller: PageController(
                          initialPage: currentIndex,
                          viewportFraction: 1,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if (isPhoto) {
                            return Stack(
                              children: [
                                InkWell(
                                  onDoubleTap: () {
                                    isLiked = !isLiked;
                                    _controller
                                        .phototLikeToggle(photos![index].id);
                                  },
                                  child: Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Base.profileBucketUrl}/${photos![index].filename}",
                                        fit: BoxFit.fitWidth,
                                        errorWidget: (c, s, e) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
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
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "${Base.profileBucketUrl}/${photos![index].owner.user_profile!.profile_img}"),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8,
                                                                right: 4),
                                                        child: InkWell(
                                                            onTap: () {
                                                              if (_controller
                                                                      .profileId !=
                                                                  photos![index]
                                                                      .owner
                                                                      .id) {
                                                                Get.to(
                                                                  () => ProfileDetail(
                                                                      profileModel: photos![index].owner,
                                                                      onBack: () {
                                                                        Get.back();
                                                                      }),
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              "@${photos![index].owner.username}",
                                                              style: style
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ),
                                                      _controller.profileId ==
                                                              photos![index]
                                                                  .owner
                                                                  .id
                                                          ? SizedBox()
                                                          : FutureBuilder<bool>(
                                                              future: _profileRepo
                                                                  .isFollowing(
                                                                      photos![index]
                                                                          .owner
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
                                                                                  12))
                                                                      : Text(
                                                                          "Follow",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12)),
                                                                  onPressed:
                                                                      () {
                                                                    Get.dialog(
                                                                        AlertDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black54,
                                                                      title: snapshot
                                                                              .data!
                                                                          ? Text(
                                                                              "Do you wish to unfollow?",
                                                                              style: TextStyle(color: Colors.white),
                                                                            )
                                                                          : Text(
                                                                              "Do you wish to follow?",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                      actionsAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                const Text("Cancel")),
                                                                        MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            Get.back();
                                                                            _controller.toggleFollowing(photos![index].owner.id);
                                                                          },
                                                                          child:
                                                                              const Text("Confirm"),
                                                                          color:
                                                                              AppColors.buttonColor,
                                                                        ),
                                                                      ],
                                                                    ));
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
                                                                            BorderRadius.circular(10.0))),
                                                                  ),
                                                                );
                                                              }),
                                                    ],
                                                  ),
                                                  Text(
                                                    parser.emojify(
                                                        photos![index].title),
                                                    style: const TextStyle(
                                                      fontSize: 15,
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
                                                          photos![index]
                                                              .content),
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
                                              width: 50,
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              child: Column(
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
                                                                  fontSize: 18,
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
                                                            isLiked = !isLiked;
                                                            _controller
                                                                .phototLikeToggle(
                                                                    photos![index]
                                                                        .id);
                                                          },
                                                          // _controller.likeVideo(data.id),
                                                          child: FutureBuilder<
                                                                  bool>(
                                                              future: _reelRepo
                                                                  .getPhotosLikeFlag(
                                                                      photos![index]
                                                                          .id,
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
                                                              .getLikeCountByPhotoId(
                                                                  photos![index]
                                                                      .id,
                                                                  _controller
                                                                      .token!),
                                                          builder:
                                                              (context, snap) {
                                                            return Text(
                                                              snap.hasData
                                                                  ? snap.data!
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
                                                          }),
                                                    ],
                                                  ),
                                                  SizedBox(height: 15),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          Get.bottomSheet(
                                                            CommentSheet(
                                                              () {
                                                                _controller
                                                                    .update();
                                                              },
                                                              id: photos![index]
                                                                  .id,
                                                              isPhoto: isPhoto,
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
                                                              .getCommentCountByPostId(
                                                                  photos![index]
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
                                                  StatefulBuilder(builder:
                                                      ((context, setState) {
                                                    return shareLoading
                                                        ? Loading()
                                                        : InkWell(
                                                            onTap: () async {
                                                              log("Working>>>>");
                                                              setState(() {
                                                                shareLoading =
                                                                    true;
                                                              });
                                                              final dl =
                                                                  await createDynamicLink(
                                                                      photos![index]
                                                                          .id,
                                                                      'photos');
                                                              log("Dynamic Link:: $dl");
                                                              setState(() {
                                                                shareLoading =
                                                                    false;
                                                              });
                                                              Share.share(dl
                                                                  .toString());
                                                            },
                                                            child: const Icon(
                                                              Icons.reply,
                                                              size: 30,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                  }))
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                _controller.showLike
                                    ? const Center(
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 100,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          } else {
                            var isPhoto = reels![index].media_ext != 'mp4';
                            var isReel = true;
                            var videoSplit = [''];
                            var videoUrl = '';
                            if (!isPhoto) {
                              videoSplit = reels![index].filename.split("_");
                              videoUrl =
                                  "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${reels![index].filename}/MP4/${reels![index].filename}";
                              if (videoSplit[0].contains('ads')) {
                                isReel = false;
                              }
                            }
                            return Stack(
                              children: [
                                isPhoto
                                    ? Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              height: double.infinity,
                                              color: Colors.black,
                                              child: InkWell(
                                                onDoubleTap: () {
                                                  isLiked = !isLiked;
                                                  isPhoto
                                                      ? _controller
                                                          .phototLikeToggle(
                                                              reels![index].id)
                                                      : _controller.likeToggle(
                                                          reels![index].id,
                                                        );
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Base.profileBucketUrl}/${reels![index].filename}",
                                                  fit: BoxFit.fitWidth,
                                                  errorWidget: (c, s, e) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: _controller.showLike
                                                ? const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 100,
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ],
                                      )
                                    : VideoPlayerItem(
                                        videoUrl: videoUrl,
                                        videoId: reels![index].id,
                                        isReel: true,
                                        updatePoints: () {},
                                        doubleTap: () {
                                          isLiked = !isLiked;
                                          _controller
                                              .likeToggle(reels![index].id);
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
                                                            CircleAvatar(
                                                              backgroundImage: isPhoto
                                                                  ? NetworkImage(
                                                                      "${Base.profileBucketUrl}/${photos![index].owner.user_profile!.profile_img}")
                                                                  : NetworkImage(
                                                                      "${Base.profileBucketUrl}/${reels![index].user.user_profile!.profile_img}"),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 8,
                                                                right: 4,
                                                              ),
                                                              child: InkWell(
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
                                                            ),
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
                                                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10.0))),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  isReel
                                                      ? HashTagText(
                                                          onTap: (tag) {
                                                            Get.to(
                                                                SearchHashTags(
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
                                                  //     debugPrint('5151' + tag);
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
                                                              Icons
                                                                  .card_giftcard,
                                                              size: 30,
                                                              color:
                                                                  Colors.white,
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
                                                                    fontSize:
                                                                        18,
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
                                                          FutureBuilder<bool>(
                                                              future: isPhoto
                                                                  ? _reelRepo.getPhotosLikeFlag(
                                                                      reels![index]
                                                                          .id,
                                                                      _controller
                                                                          .token!)
                                                                  : _reelRepo.getLikeFlag(
                                                                      reels![index]
                                                                          .id,
                                                                      _controller
                                                                          .token!),
                                                              builder: (context,
                                                                  snap) {
                                                                isLiked = snap
                                                                        .hasData
                                                                    ? snap.data!
                                                                        ? true
                                                                        : false
                                                                    : false;
                                                                return InkWell(
                                                                  onTap: () {
                                                                    isLiked =
                                                                        !isLiked;
                                                                    _controller.likeToggle(
                                                                        index,
                                                                        isPhoto:
                                                                            isPhoto);
                                                                  },
                                                                  child: Icon(
                                                                    isLiked
                                                                        ? Icons
                                                                            .favorite
                                                                        : Icons
                                                                            .favorite_border,
                                                                    size: 30,
                                                                    color: isLiked
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                );
                                                              }),
                                                          // const SizedBox(height: 7),
                                                          FutureBuilder<int>(
                                                              future: isPhoto
                                                                  ? _reelRepo.getLikeCountByPhotoId(
                                                                      reels![index]
                                                                          .id,
                                                                      _controller
                                                                          .token!)
                                                                  : _reelRepo.getLikeCountByReelId(
                                                                      reels![index]
                                                                          .id,
                                                                      _controller
                                                                          .token!),
                                                              builder: (context,
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
                                                                  id: reels![
                                                                          index]
                                                                      .id,
                                                                  isPhoto:
                                                                      isPhoto,
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
                                                          FutureBuilder<int>(
                                                              future: isPhoto
                                                                  ? _commentRepo.getCommentCountByPostId(
                                                                      reels![index]
                                                                          .id,
                                                                      _controller
                                                                          .token!)
                                                                  : _commentRepo.getCommentCountByReelId(
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
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                );
                                                              })
                                                        ],
                                                      ),
                                                      SizedBox(height: 15),
                                                      StatefulBuilder(builder:
                                                          (context, setState) {
                                                        return shareLoading
                                                            ? Loading()
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  setState(() {
                                                                    shareLoading =
                                                                        true;
                                                                  });
                                                                  final dl = await createDynamicLink(
                                                                      reels![index]
                                                                          .id,
                                                                      'reels');
                                                                  log("Dynamic Link:: $dl");
                                                                  setState(() {
                                                                    shareLoading =
                                                                        false;
                                                                  });
                                                                  Share.share(dl
                                                                      .toString());
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.reply,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              );
                                                      })
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
                                                                color: Colors
                                                                    .white,
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
                          }
                        },
                      ),
              ),
            ));
  }
}
