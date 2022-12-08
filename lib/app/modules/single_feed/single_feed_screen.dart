// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:readmore/readmore.dart';
import 'package:reel_ro/app/modules/profile/profile_controller.dart';
import 'package:share_plus/share_plus.dart';

import 'package:reel_ro/app/modules/single_feed/single_feed_controller.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/widgets/loading.dart';

import '../../../models/photo_model.dart';
import '../../../models/profile_model.dart';
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
import '../homepage/homepage_screen.dart';
import '../homepage/profile_detail_screen.dart';
import '../search/search_screen.dart';

class SingleFeedScreen extends StatelessWidget {
  SingleFeedScreen(
      this.photos, this.reels, this.currentIndex, this.profileController,
      {this.openComment = false, this.isPhoto = false, Key? key})
      : super(key: key);
  final bool isPhoto;
  final List<ReelModel>? reels;
  final List<PhotoModel>? photos;
  int currentIndex;
  final ProfileController? profileController;
  bool openComment;
  final controller = Get.put(SingleFeedController());
  final _reelRepo = Get.put(ReelRepository());
  final _commentRepo = Get.put(CommentRepository());
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _profileRepo = Get.put(ProfileRepository());
  final myMenuItems = <String>[
    'Report',
  ];
  bool shareLoading = false;

  late ConfettiController _controllerCenter;
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
    );
    var dynamicUrl = await dynamicLinks.buildShortLink(parameters);
    final Uri shortUrl = dynamicUrl.shortUrl;
    log("link:: $shortUrl");
    return shortUrl;
  }

  void onSelect(int id, int index, String reason) {
    controller.reportReelOrComment(reason, 'reel', id, () {
      // controller.reportList.add(id);
      // controller.removeReel(index);

      moveNextReel(index + 1);
    });
  }

  void moveNextReel(int index) {
    pageController.jumpToPage(index);
    controller.update();
  }

  void openCommentSheet() {
    if (openComment) {
      Get.bottomSheet(
        CommentSheet(
          () {
            controller.update();
          },
          id: reels![currentIndex].id,
          isPhoto: isPhoto,
        ),
        backgroundColor: Colors.white,
      );
      openComment = false;
    }
  }

  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  @override
  Widget build(BuildContext context) {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    pageController = PageController(
      initialPage: currentIndex,
      viewportFraction: 1,
    );
    final theme = Get.theme;
    final style = theme.textTheme;
    final parser = EmojiParser();
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
                  actions: [
                    if ((isPhoto
                            ? photos![currentIndex].owner.id
                            : reels![currentIndex].user.id) ==
                        controller.profileId)
                      IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                height: Get.height * 0.15,
                                color: Colors.white,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            String caption = '';
                                            Get.back();
                                            Get.dialog(AlertDialog(
                                              title: const Text("Edit Caption"),
                                              content: TextFormField(
                                                decoration: InputDecoration(
                                                  hintText: parser.emojify(
                                                      isPhoto
                                                          ? photos![
                                                                  currentIndex]
                                                              .content
                                                          : reels![currentIndex]
                                                              .description),
                                                  counterText: '',
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                // validator: (v) =>
                                                //     v!.isNotEmpty && v.length != 2 ? "Country code must be 2 digits" : null,
                                                onChanged: (v) => caption = (v),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child:
                                                        const Text("Cancel")),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    Get.back();
                                                    if (caption != '') {
                                                      Get.back();
                                                      isPhoto
                                                          ? await controller
                                                              .updatePhotoCation(
                                                                  photos![currentIndex]
                                                                      .id,
                                                                  caption,
                                                                  photos![currentIndex]
                                                                      .title)
                                                          : await controller
                                                              .updateReelCaption(
                                                                  reels![currentIndex]
                                                                      .id,
                                                                  caption);
                                                      await profileController!
                                                          .onInit();
                                                    }
                                                  },
                                                  child: const Text("Save"),
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ));
                                          },
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 17),
                                          )),
                                      ElevatedButton(
                                          onPressed: () {
                                            isPhoto
                                                ? Get.dialog(AlertDialog(
                                                    title: const Text(
                                                        "Are you sure you want to delete this post?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text("NO")),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          Get.back();
                                                          Get.back();
                                                          Get.back();
                                                          profileController!
                                                              .deletePost(photos![
                                                                      currentIndex]
                                                                  .id);
                                                        },
                                                        child:
                                                            const Text("YES"),
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ))
                                                : Get.dialog(AlertDialog(
                                                    title: const Text(
                                                        "Are you sure you want to delete this roll?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text("NO")),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          Get.back();
                                                          Get.back();
                                                          Get.back();
                                                          profileController!
                                                              .deleteReel(reels![
                                                                      currentIndex]
                                                                  .id);
                                                        },
                                                        child:
                                                            const Text("YES"),
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ));
                                          },
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(fontSize: 17),
                                          ))
                                    ]),
                              ),
                            );
                          },
                          icon: Icon(Icons.more_vert))
                  ],
                ),
                body: Container(
                  color: Colors.black,
                  child: controller.loading
                      ? Loading()
                      : PageView.builder(
                          onPageChanged: (i) {
                            currentIndex = i;
                          },
                          allowImplicitScrolling: true,
                          itemCount: isPhoto ? photos!.length : reels!.length,
                          controller: pageController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            // currentIndex = index;
                            final Rx<ReportReason?> _reason =
                                ReportReason.hateSpeech.obs;

                            var isMe = controller.profileId ==
                                (isPhoto
                                    ? photos![index].owner.id
                                    : reels![index].user.id);
                            if (isPhoto) {
                              return Stack(
                                children: [
                                  InkWell(
                                    onDoubleTap: () {
                                      isLiked = !isLiked;
                                      controller
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                if (controller
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
                                                        controller.profileId ==
                                                                photos![index]
                                                                    .owner
                                                                    .id
                                                            ? SizedBox()
                                                            : FutureBuilder<
                                                                    bool>(
                                                                future: _profileRepo.isFollowing(
                                                                    photos![index]
                                                                        .owner
                                                                        .id,
                                                                    controller
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
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 12)),
                                                                    onPressed:
                                                                        () {
                                                                      Get.dialog(
                                                                          AlertDialog(
                                                                        backgroundColor:
                                                                            Colors.black54,
                                                                        title: snapshot.data!
                                                                            ? Text(
                                                                                "Do you wish to unfollow?",
                                                                                style: TextStyle(color: Colors.white),
                                                                              )
                                                                            : Text(
                                                                                "Do you wish to follow?",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                        actionsAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                              child: const Text("Cancel")),
                                                                          MaterialButton(
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                              controller.toggleFollowing(photos![index].owner.id);
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
                                                                              color: Colors.white,
                                                                              width: 1,
                                                                              style: BorderStyle.solid),
                                                                          borderRadius: BorderRadius.circular(10.0))),
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
                                                                    controller
                                                                        .profileId!,
                                                                    controller
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
                                                              isLiked =
                                                                  !isLiked;
                                                              controller
                                                                  .phototLikeToggle(
                                                                      photos![index]
                                                                          .id);
                                                            },
                                                            onLongPress: () {
                                                              Get.dialog(
                                                                  AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                title:
                                                                    const Text(
                                                                  "Liked By",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            22,
                                                                            22,
                                                                            22,
                                                                            1),
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                content: FutureBuilder<
                                                                        List<
                                                                            ProfileModel>>(
                                                                    future: ProfileRepository().getUserLikesByPhoto(
                                                                        photos![index]
                                                                            .id
                                                                            .toString(),
                                                                        controller
                                                                            .token!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Loading();
                                                                      }
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        printInfo(
                                                                            info:
                                                                                "getFollowersByUserId: ${snapshot.hasError}");
                                                                        return Container();
                                                                      }
                                                                      return Container(
                                                                        height: Get.height *
                                                                            0.7,
                                                                        width: Get.width *
                                                                            0.7,
                                                                        child:
                                                                            Material(
                                                                          child:
                                                                              ListView.builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                const ClampingScrollPhysics(),
                                                                            itemCount:
                                                                                snapshot.data!.length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return ListTile(
                                                                                onTap: () {
                                                                                  if (snapshot.data![index].id != controller.profileId) {
                                                                                    Get.to(
                                                                                      ProfileDetail(
                                                                                        profileModel: snapshot.data![index],
                                                                                        onBack: () {
                                                                                          Get.back();
                                                                                        },
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                },
                                                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                leading: CircleAvatar(
                                                                                  radius: 25,
                                                                                  backgroundColor: theme.colorScheme.primary,
                                                                                  backgroundImage: NetworkImage(
                                                                                    snapshot.data![index].user_profile != null ? "${Base.profileBucketUrl}/${snapshot.data![index].user_profile!.profile_img}" : "",
                                                                                  ),
                                                                                ),
                                                                                title: Text(
                                                                                  snapshot.data![index].user_profile!.fullname!,
                                                                                  style: style.titleMedium!.copyWith(
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                subtitle: Text(
                                                                                  snapshot.data![index].username!,
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                              ));
                                                            },
                                                            child: FutureBuilder<
                                                                    bool>(
                                                                future: _reelRepo.getPhotosLikeFlag(
                                                                    photos![index]
                                                                        .id,
                                                                    controller
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
                                                        FutureBuilder<int>(
                                                            future: _reelRepo
                                                                .getLikeCountByPhotoId(
                                                                    photos![index]
                                                                        .id,
                                                                    controller
                                                                        .token!),
                                                            builder: (context,
                                                                snap) {
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
                                                                  controller
                                                                      .update();
                                                                },
                                                                id: photos![
                                                                        index]
                                                                    .id,
                                                                isPhoto:
                                                                    isPhoto,
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
                                                                    controller
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
                                                                color: Colors
                                                                    .white,
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
                                  controller.showLike
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
                                videoUrl = reels![index].filepath;
                                // "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${reels![index].filename}/MP4/${reels![index].filename}";
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
                                                        ? controller
                                                            .phototLikeToggle(
                                                                reels![index]
                                                                    .id)
                                                        : controller.likeToggle(
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
                                              child: controller.showLike
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
                                            controller
                                                .likeToggle(reels![index].id);
                                          },
                                          swipeRight: () {},
                                          showLike: controller.showLike,
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
                                                    left: 20, bottom: 30),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    isReel
                                                        ? InkWell(
                                                            onTap: () {
                                                              if (controller
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
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          "${Base.profileBucketUrl}/${reels![index].user.user_profile!.profile_img}"),
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 8,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      "${reels![index].user.username}",
                                                                      style: style
                                                                          .titleMedium!
                                                                          .copyWith(
                                                                        color: Colors
                                                                            .grey[400],
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                isMe
                                                                    ? SizedBox()
                                                                    : isReel
                                                                        ? FutureBuilder<
                                                                                bool>(
                                                                            future:
                                                                                _profileRepo.isFollowing(reels![index].user.id, controller.token!),
                                                                            builder: (context, snapshot) {
                                                                              if (!snapshot.hasData) {
                                                                                return Container();
                                                                              }
                                                                              return TextButton(
                                                                                child: snapshot.data! ? Text("Following", style: TextStyle(color: Colors.grey[400], fontSize: 12)) : Text("Follow", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                                                                onPressed: () {
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
                                                                                          controller.toggleFollowing(reels![index].user.id);
                                                                                        },
                                                                                        child: const Text("Confirm"),
                                                                                        color: AppColors.buttonColor,
                                                                                      ),
                                                                                    ],
                                                                                  ));
                                                                                },
                                                                                style: ButtonStyle(
                                                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(side: BorderSide(color: Colors.grey[400]!, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10.0))),
                                                                                ),
                                                                              );
                                                                            })
                                                                        : SizedBox(),
                                                              ],
                                                            ),
                                                          )
                                                        : Row(
                                                            children: [
                                                              Text(
                                                                "@sponsored  ",
                                                                style: style
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 150,
                                                                  child:
                                                                      TextButton(
                                                                    child: Text(
                                                                        "Click Here",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey[400],
                                                                            fontSize: 12)),
                                                                    onPressed:
                                                                        () {
                                                                      Get.to(WebViewScreen(
                                                                          'https://flutter.dev'));
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                              color: Colors.grey[400]!,
                                                                              width: 1,
                                                                              style: BorderStyle.solid),
                                                                          borderRadius: BorderRadius.circular(10.0))),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                    if (reels![index]
                                                            .video_title !=
                                                        '')
                                                      ReadMoreText(
                                                        parser.emojify(
                                                            reels![index]
                                                                .video_title),
                                                        trimLength: 20,
                                                        colorClickableText:
                                                            Colors.pink,
                                                        trimMode:
                                                            TrimMode.Length,
                                                        trimCollapsedText:
                                                            '(...)',
                                                        trimExpandedText:
                                                            ' (Show less)',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.grey[400],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        lessStyle: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.grey[400],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        moreStyle: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.grey[400],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    if (isReel)
                                                      if (reels![index]
                                                              .description !=
                                                          '')
                                                        HashTagText(
                                                            onTap: (tag) {
                                                              Get.to(
                                                                  SearchHashTags(
                                                                hashTag: tag,
                                                              ));
                                                            },
                                                            text: parser
                                                                .emojify(reels![
                                                                        index]
                                                                    .description),
                                                            basicStyle:
                                                                TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                            decoratedStyle:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.blue,
                                                            )),
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
                                                              child: Icon(
                                                                Icons
                                                                    .card_giftcard,
                                                                size: 30,
                                                                color: Colors
                                                                    .grey[400]!,
                                                              ),
                                                            ),
                                                            FutureBuilder<
                                                                    String>(
                                                                future: _giveawayRepo.getTotalEntryCountByUserId(
                                                                    controller
                                                                        .profileId!,
                                                                    controller
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
                                                                            .grey[400],
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
                                                                              .grey[
                                                                          400],
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
                                                                      controller
                                                                          .token!)
                                                                  : _reelRepo.getLikeFlag(
                                                                      reels![index]
                                                                          .id,
                                                                      controller
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
                                                                  onLongPress:
                                                                      () {
                                                                    Get.dialog(
                                                                        AlertDialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      title:
                                                                          const Text(
                                                                        "Liked By",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              22,
                                                                              22,
                                                                              22,
                                                                              1),
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      content: FutureBuilder<
                                                                              List<
                                                                                  ProfileModel>>(
                                                                          future: ProfileRepository().getUserLikesByReel(
                                                                              reels![index].id.toString(),
                                                                              controller.token!),
                                                                          builder: (context, snapshot) {
                                                                            if (!snapshot.hasData) {
                                                                              return Loading();
                                                                            }
                                                                            if (snapshot.hasError) {
                                                                              printInfo(info: "getFollowersByUserId: ${snapshot.hasError}");
                                                                              return Container();
                                                                            }
                                                                            return Container(
                                                                              height: Get.height * 0.7,
                                                                              width: Get.width * 0.7,
                                                                              child: Material(
                                                                                child: ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  physics: const ClampingScrollPhysics(),
                                                                                  itemCount: snapshot.data!.length,
                                                                                  itemBuilder: (BuildContext context, int index) {
                                                                                    return ListTile(
                                                                                      onTap: () {
                                                                                        if (snapshot.data![index].id != controller.profileId) {
                                                                                          Get.to(
                                                                                            ProfileDetail(
                                                                                              profileModel: snapshot.data![index],
                                                                                              onBack: () {
                                                                                                Get.back();
                                                                                              },
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                      leading: CircleAvatar(
                                                                                        radius: 25,
                                                                                        backgroundColor: theme.colorScheme.primary,
                                                                                        backgroundImage: NetworkImage(
                                                                                          snapshot.data![index].user_profile != null ? "${Base.profileBucketUrl}/${snapshot.data![index].user_profile!.profile_img}" : "",
                                                                                        ),
                                                                                      ),
                                                                                      title: Text(
                                                                                        snapshot.data![index].user_profile!.fullname!,
                                                                                        style: style.titleMedium!.copyWith(
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                      subtitle: Text(
                                                                                        snapshot.data![index].username!,
                                                                                        maxLines: 2,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    ));
                                                                  },
                                                                  onTap: () {
                                                                    isLiked =
                                                                        !isLiked;
                                                                    controller.likeToggle(
                                                                        reels![index]
                                                                            .id,
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
                                                                            .grey[400],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            FutureBuilder<int>(
                                                                future: isPhoto
                                                                    ? _reelRepo.getLikeCountByPhotoId(
                                                                        reels![index]
                                                                            .id,
                                                                        controller
                                                                            .token!)
                                                                    : _reelRepo.getLikeCountByReelId(
                                                                        reels![index]
                                                                            .id,
                                                                        controller
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
                                                                    style: style
                                                                        .headlineSmall!
                                                                        .copyWith(
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
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
                                                                      controller
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
                                                              child: Icon(
                                                                Icons.comment,
                                                                size: 30,
                                                                color: Colors
                                                                    .grey[400],
                                                              ),
                                                            ),
                                                            FutureBuilder<int>(
                                                                future: isPhoto
                                                                    ? _commentRepo.getCommentCountByPostId(
                                                                        reels![index]
                                                                            .id,
                                                                        controller
                                                                            .token!)
                                                                    : _commentRepo.getCommentCountByReelId(
                                                                        reels![index]
                                                                            .id,
                                                                        controller
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
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  );
                                                                })
                                                          ],
                                                        ),
                                                        SizedBox(height: 15),
                                                        controller.shareLoading
                                                            ? Loading()
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  log("Working>>>>");
                                                                  final dl = await createDynamicLink(
                                                                      reels![index]
                                                                          .id,
                                                                      'reels');
                                                                  log("Dynamic Link:: $dl");
                                                                  Share.share(dl
                                                                      .toString());
                                                                },
                                                                child: Icon(
                                                                  Icons.reply,
                                                                  size: 30,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                              ),
                                                        SizedBox(height: 15),
                                                        PopupMenuButton<String>(
                                                            child: Icon(
                                                              Icons.more_vert,
                                                              size: 30,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                            onSelected:
                                                                (v) async {
                                                              final val =
                                                                  await Get.dialog(
                                                                      AlertDialog(
                                                                title: const Text(
                                                                    "Please select the reason:"),
                                                                content: Obx(
                                                                    () =>
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: <
                                                                              Widget>[
                                                                            RadioListTile<ReportReason>(
                                                                              title: const Text('Hate Speech'),
                                                                              value: ReportReason.hateSpeech,
                                                                              groupValue: _reason.value,
                                                                              onChanged: (ReportReason? value) {
                                                                                _reason.value = value;
                                                                              },
                                                                            ),
                                                                            RadioListTile<ReportReason>(
                                                                              title: const Text('Bullying'),
                                                                              value: ReportReason.bullying,
                                                                              groupValue: _reason.value,
                                                                              onChanged: (ReportReason? value) {
                                                                                _reason.value = value;
                                                                              },
                                                                            ),
                                                                            RadioListTile<ReportReason>(
                                                                              title: const Text('Impersonation'),
                                                                              value: ReportReason.impersonation,
                                                                              groupValue: _reason.value,
                                                                              onChanged: (ReportReason? value) {
                                                                                _reason.value = value;
                                                                              },
                                                                            ),
                                                                            RadioListTile<ReportReason>(
                                                                              title: const Text('Illegal content'),
                                                                              value: ReportReason.illegalContent,
                                                                              groupValue: _reason.value,
                                                                              onChanged: (ReportReason? value) {
                                                                                _reason.value = value;
                                                                              },
                                                                            ),
                                                                            RadioListTile<ReportReason>(
                                                                              title: const Text('Abusive content'),
                                                                              value: ReportReason.abusiveContent,
                                                                              groupValue: _reason.value,
                                                                              onChanged: (ReportReason? value) {
                                                                                _reason.value = value;
                                                                              },
                                                                            ),
                                                                          ],
                                                                        )),
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
                                                                      Get.back(
                                                                          result:
                                                                              true);
                                                                    },
                                                                    child: const Text(
                                                                        "Report"),
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ],
                                                              ));
                                                              if (val != null) {
                                                                onSelect(
                                                                    reels![index]
                                                                        .id,
                                                                    index,
                                                                    _reason
                                                                        .value
                                                                        .toString());
                                                                reels!.removeAt(
                                                                    index);
                                                              }
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
                                                                  value: choice,
                                                                );
                                                              }).toList();
                                                            })
                                                      ],
                                                    )
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        ConfettiWidget(
                                                          confettiController:
                                                              _controllerCenter,
                                                          blastDirectionality:
                                                              BlastDirectionality
                                                                  .explosive,
                                                          shouldLoop: false,
                                                          colors: const [
                                                            Colors.green,
                                                            Colors.blue,
                                                            Colors.pink,
                                                            Colors.orange,
                                                            Colors.purple
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(
                                                                EntryCountView());
                                                          },
                                                          child:
                                                              // Obx(() =>
                                                              // AnimatedRotation(
                                                              //   turns: turns
                                                              //       .value,
                                                              //   duration:
                                                              //       const Duration(seconds: 1),
                                                              //   child:
                                                              const Icon(
                                                            Icons.card_giftcard,
                                                            size: 30,
                                                            color: Colors.pink,
                                                          ),
                                                          // )),
                                                        ),
                                                        FutureBuilder<String>(
                                                          future: _giveawayRepo
                                                              .getTotalEntryCountByUserId(
                                                                  controller
                                                                      .profileId!,
                                                                  controller
                                                                      .token!),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return Loading();
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
                                                          },
                                                        )
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
                            }
                          },
                        ),
                ),
              ),
            ));
  }
}
