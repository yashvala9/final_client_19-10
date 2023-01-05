// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import 'package:reel_ro/app/modules/WebView/webview.dart';
import 'package:reel_ro/app/modules/homepage/homepage_controller.dart';
import 'package:reel_ro/app/modules/homepage/widgets/coin_animation.dart';
import 'package:reel_ro/app/modules/profile/profile_controller.dart';
import 'package:reel_ro/repositories/comment_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:share_plus/share_plus.dart';
import '../../../repositories/giveaway_repository.dart';
import '../../../repositories/profile_repository.dart';
import '../../../utils/base.dart';
import '../../../utils/colors.dart';
import '../../../utils/video_player_item.dart';
import '../../notification_screen.dart';
import '../add_feed/add_feed_screen.dart';
import '../add_feed/widgets/video_trimmer_view.dart';
import '../entry_count/views/entry_count_view.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import 'comment_screen.dart';

import 'profile_detail_screen.dart';

enum ReportReason {
  hateSpeech,
  bullying,
  impersonation,
  illegalContent,
  abusiveContent
}

class DemoClass extends StatelessWidget {
  const DemoClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  final _reelRepo = Get.put(ReelRepository());
  final _profileRepo = Get.put(ProfileRepository());
  final controller = Get.put(HomePageController());
  final _commentRepo = Get.put(CommentRepository());
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _profileController = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());
  final myMenuItems = <String>[
    'Report',
  ];
  late ConfettiController _controllerCenter;
  final bool isAnimationPlaying = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<Uri> createDynamicLink(int id, String type) async {
    log("Type:: $type");
    controller.shareLoading = true;
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
    controller.shareLoading = false;
    return shortUrl;
  }

  void onSelect(int id, int index, String reason) {
    controller.reportReelOrComment(reason, 'reel', id, () {
      // controller.reportList.add(id);
      controller.onInit();
      // moveNextReel(index + 1);
      // controller.removeReel(index);
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  PageController pageController2 = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );

  void moveNextReel(int index) {
    pageController.jumpToPage(index);
    controller.updateManually();
  }

  void moveToReel() {
    pageController2.animateTo(0,
        curve: Curves.linear, duration: Duration(milliseconds: 600));
    controller.updateManually();
  }

  void goToFirstPage() {
    pageController.animateToPage(0,
        curve: Curves.fastOutSlowIn, duration: Duration(seconds: 1));
    controller.updateManually();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final parser = EmojiParser();
    var isLiked = false;
    RxDouble turns = 0.0.obs;
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));

    void _changeRotation() {
      turns.value += 1.0;
    }

    var reels = controller.reelList;
    return GetBuilder<HomePageController>(
      builder: (_) => SafeArea(
        child: controller.loading
            ? Loading()
            : RefreshIndicator(
                onRefresh: () async {
                  await controller.getFeeds();
                  return Future.value();
                },
                child: Obx(
                  () => reels.value.isEmpty
                      ? EmptyWidget("No reels available!")
                      : PageView.builder(
                          allowImplicitScrolling: true,
                          itemCount: reels.value.length,
                          controller: pageController,
                          physics: controller.secondPageIndex > 0
                              ? NeverScrollableScrollPhysics()
                              : AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final Rx<ReportReason?> _reason =
                                ReportReason.hateSpeech.obs;
                            var isReel = true;
                            if (index == (reels.value.length - 3) &&
                                !controller.loadingMore) {
                              controller.getMoreFeed();
                            }
                            final data = reels.value[index];
                            var isMe = controller.profileId == data.user.id;
                            var videoSplit = [''];
                            var videoUrl = "";

                            var isPhoto = data.media_ext != 'mp4';
                            if (!isPhoto) {
                              videoSplit = data.filename.split("_");
                              videoUrl = data.filepath;
                              // "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${data.filename}/MP4/${data.filename}";
                              if (videoSplit[0].contains('ads')) {
                                isReel = false;
                              }
                            }
                            return PageView.builder(
                              itemCount: isReel
                                  ? isMe
                                      ? 1
                                      : 2
                                  : 1,
                              controller: pageController2,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (v) {
                                controller.secondPageIndex = v;
                              },
                              itemBuilder: (context, index2) {
                                if (index2 == 0) {
                                  return Scaffold(
                                    backgroundColor: Colors.black,
                                    extendBodyBehindAppBar: true,
                                    appBar: AppBar(
                                      leading:
                                          !isReel ? Text('    Ad') : SizedBox(),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      centerTitle: true,
                                      actions: [
                                        isReel
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.notifications_none,
                                                ),
                                                onPressed: () {
                                                  Get.to(NotificationScreen());
                                                })
                                            : SizedBox(),
                                        isReel
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.add_box_outlined,
                                                ),
                                                onPressed: () async {
                                                  final val = await showDialog(
                                                    context: context,
                                                    builder: (_) => Dialog(
                                                        child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ListTile(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context, true);
                                                          },
                                                          leading: Icon(
                                                              Icons.video_call),
                                                          title: Text("Video"),
                                                        ),
                                                        ListTile(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context, false);
                                                          },
                                                          leading:
                                                              Icon(Icons.photo),
                                                          title: Text("Photo"),
                                                        ),
                                                      ],
                                                    )),
                                                  );
                                                  if (val != null) {
                                                    if (val) {
                                                      var video = await ImagePicker()
                                                          .pickVideo(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                      if (video != null) {
                                                        final val =
                                                            await Navigator.of(
                                                                    context)
                                                                .push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                            return VideoTrimmerView(
                                                                File(video
                                                                    .path));
                                                          }),
                                                        );
                                                        if (val != null) {
                                                          log("VideoAdded: $val");
                                                          _profileController
                                                              .updateManually();
                                                        }
                                                      }
                                                    } else {
                                                      var photo = await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                      if (photo != null) {
                                                        Get.to(
                                                          () => AddFeedScreen(
                                                            file: File(
                                                                photo.path),
                                                            type: 1,
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                              )
                                            : SizedBox(),
                                        // CoinAnimation(5),
                                      ],
                                    ),
                                    body: Stack(
                                      children: [
                                        isPhoto
                                            ? Stack(
                                                children: [
                                                  Center(
                                                    child: InkWell(
                                                      onDoubleTap: () {
                                                        isLiked = !isLiked;
                                                        controller.likeToggle(
                                                            index,
                                                            isPhoto: isPhoto);
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${Base.profileBucketUrl}/${data.filename}",
                                                        fit: BoxFit.cover,
                                                        errorWidget: (c, s,
                                                                e) =>
                                                            const Icon(
                                                                Icons.error),
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
                                                thumbnail: data.thumbnail,
                                                videoId: data.id,
                                                isReel: isReel,
                                                points: data.points,
                                                updatePoints: () {
                                                  _controllerCenter.play();

                                                  controller.updateManually();
                                                  _changeRotation();
                                                },
                                                doubleTap: () {
                                                  if (isReel) {
                                                    isLiked = !isLiked;
                                                    controller
                                                        .likeToggle(index);
                                                  }
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              bottom: 30),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          isReel
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    if (controller
                                                                            .profileId !=
                                                                        data.user
                                                                            .id) {
                                                                      Get.to(
                                                                        () => ProfileDetail(
                                                                            profileModel: data.user,
                                                                            onBack: () {
                                                                              Get.back();
                                                                            }),
                                                                      );
                                                                    } else {
                                                                      Get.to(() =>
                                                                          ProfileScreen());
                                                                    }
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundImage:
                                                                            NetworkImage("${Base.profileBucketUrl}/${data.user.user_profile!.profile_img}"),
                                                                      ),
                                                                      Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                            left:
                                                                                8,
                                                                            right:
                                                                                4,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "${data.user.username}",
                                                                            style:
                                                                                style.titleMedium!.copyWith(
                                                                              color: Colors.grey[400],
                                                                            ),
                                                                          )),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      isMe
                                                                          ? SizedBox()
                                                                          : isReel
                                                                              ? FutureBuilder<bool>(
                                                                                  future: _profileRepo.isFollowing(data.user.id, controller.token!),
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
                                                                                                controller.toggleFollowing(data.user.id);
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
                                                                            .grey[400],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            150,
                                                                        child:
                                                                            TextButton(
                                                                          child: Text(
                                                                              "Click Here",
                                                                              style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                                                          onPressed:
                                                                              () {
                                                                            Get.to(WebViewScreen('https://flutter.dev'));
                                                                          },
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all(RoundedRectangleBorder(side: BorderSide(color: Colors.grey[400]!, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10.0))),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                          if (data.video_title !=
                                                              '')
                                                            ReadMoreText(
                                                              parser.emojify(data
                                                                  .video_title),
                                                              trimLength: 20,
                                                              colorClickableText:
                                                                  Colors.pink,
                                                              trimMode: TrimMode
                                                                  .Length,
                                                              trimCollapsedText:
                                                                  '(...)',
                                                              trimExpandedText:
                                                                  ' (Show less)',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey[400],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              lessStyle:
                                                                  TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey[400],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              moreStyle:
                                                                  TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey[400],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          if (isReel)
                                                            if (data.description !=
                                                                '')
                                                              HashTagText(
                                                                  onTap: (tag) {
                                                                    Get.to(
                                                                        SearchHashTags(
                                                                      hashTag:
                                                                          tag,
                                                                    ));
                                                                  },
                                                                  text: parser
                                                                      .emojify(data
                                                                          .description),
                                                                  basicStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                  ),
                                                                  decoratedStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .blue,
                                                                  )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    margin: isReel
                                                        ? EdgeInsets.only(
                                                            bottom: 15)
                                                        : EdgeInsets.only(
                                                            bottom: 50),
                                                    child: isReel
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
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
                                                                              .grey[
                                                                          400]!,
                                                                    ),
                                                                  ),
                                                                  FutureBuilder<
                                                                          String>(
                                                                      future: _giveawayRepo.getTotalEntryCountByUserId(
                                                                          controller
                                                                              .profileId!,
                                                                          controller
                                                                              .token!),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Text(
                                                                            "0",
                                                                            style:
                                                                                style.headlineSmall!.copyWith(
                                                                              fontSize: 18,
                                                                              color: Colors.grey[400],
                                                                            ),
                                                                          );
                                                                        }
                                                                        if (snapshot
                                                                            .hasError) {
                                                                          printInfo(
                                                                              info: "getTotalEntryCountByUserId: ${snapshot.hasError}");
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
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 15),
                                                              Column(
                                                                children: [
                                                                  FutureBuilder<
                                                                      bool>(
                                                                    future: isPhoto
                                                                        ? _reelRepo.getPhotosLikeFlag(
                                                                            data
                                                                                .id,
                                                                            controller
                                                                                .token!)
                                                                        : _reelRepo.getLikeFlag(
                                                                            data.id,
                                                                            controller.token!),
                                                                    builder:
                                                                        (context,
                                                                            snap) {
                                                                      isLiked = snap
                                                                              .hasData
                                                                          ? snap.data!
                                                                              ? true
                                                                              : false
                                                                          : false;
                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          isLiked =
                                                                              !isLiked;
                                                                          controller.likeToggle(
                                                                              index,
                                                                              isPhoto: isPhoto);
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          isLiked
                                                                              ? Icons.favorite
                                                                              : Icons.favorite_border,
                                                                          size:
                                                                              30,
                                                                          color: isLiked
                                                                              ? Colors.red
                                                                              : Colors.grey[400],
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  FutureBuilder<
                                                                          int>(
                                                                      future: isPhoto
                                                                          ? _reelRepo.getLikeCountByPhotoId(
                                                                              data
                                                                                  .id,
                                                                              controller
                                                                                  .token!)
                                                                          : _reelRepo.getLikeCountByReelId(
                                                                              data
                                                                                  .id,
                                                                              controller
                                                                                  .token!),
                                                                      builder:
                                                                          (context,
                                                                              snap) {
                                                                        return Text(
                                                                          snap.hasData
                                                                              ? snap.data!.toString()
                                                                              : '0',
                                                                          style: style
                                                                              .headlineSmall!
                                                                              .copyWith(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                        );
                                                                      }),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 15),
                                                              Column(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.bottomSheet(
                                                                        CommentSheet(
                                                                          () {
                                                                            controller.update();
                                                                          },
                                                                          id: data
                                                                              .id,
                                                                          isPhoto:
                                                                              isPhoto,
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .comment,
                                                                      size: 30,
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                  FutureBuilder<
                                                                          int>(
                                                                      future: isPhoto
                                                                          ? _commentRepo.getCommentCountByPostId(
                                                                              data
                                                                                  .id,
                                                                              controller
                                                                                  .token!)
                                                                          : _commentRepo.getCommentCountByReelId(
                                                                              data
                                                                                  .id,
                                                                              controller
                                                                                  .token!),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        return Text(
                                                                          snapshot.hasData
                                                                              ? snapshot.data!.toString()
                                                                              : '0',
                                                                          style: style
                                                                              .headlineSmall!
                                                                              .copyWith(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 15),
                                                              controller
                                                                      .shareLoading
                                                                  ? Loading()
                                                                  : InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        log("Working>>>>");
                                                                        final dl = await createDynamicLink(
                                                                            data.id,
                                                                            'reels');
                                                                        log("Dynamic Link:: $dl");
                                                                        Share.share(
                                                                            dl.toString());
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .reply,
                                                                        size:
                                                                            30,
                                                                        color: Colors
                                                                            .grey[400],
                                                                      ),
                                                                    ),
                                                              SizedBox(
                                                                  height: 15),
                                                              PopupMenuButton<
                                                                      String>(
                                                                  child: Icon(
                                                                    Icons
                                                                        .more_vert,
                                                                    size: 30,
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
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
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
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
                                                                            child:
                                                                                const Text("Cancel")),
                                                                        MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            Get.back(result: true);
                                                                          },
                                                                          child:
                                                                              const Text("Report"),
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ],
                                                                    ));
                                                                    if (val !=
                                                                        null) {
                                                                      onSelect(
                                                                          data
                                                                              .id,
                                                                          index,
                                                                          _reason
                                                                              .value
                                                                              .toString());
                                                                      reels
                                                                          .value
                                                                          .removeAt(
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
                                                                    .end,
                                                            children: [
                                                              ConfettiWidget(
                                                                confettiController:
                                                                    _controllerCenter,
                                                                blastDirectionality:
                                                                    BlastDirectionality
                                                                        .explosive,
                                                                shouldLoop:
                                                                    false,
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
                                                                  Icons
                                                                      .card_giftcard,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .pink,
                                                                ),
                                                                // )),
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
                                    ),
                                  );
                                } else {
                                  return isReel
                                      ? ProfileDetail(
                                          profileModel: controller
                                              .reelList.value[index].user,
                                          onBack: () {
                                            moveToReel();
                                          },
                                        )
                                      : WebViewScreen("https://flutter.dev/");
                                }
                              },
                            );
                          }),
                ),
              ),
      ),
    );
  }
}
