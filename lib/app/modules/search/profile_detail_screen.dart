import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/profile_detail_controller.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/models/profile_model.dart';

import '../../../models/photo_model.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';
import '../../../utils/assets.dart';
import '../../../utils/base.dart';
import '../../../utils/empty_widget.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/my_elevated_button.dart';
import '../list_users/list_users_view.dart';
import '../profile/profile_screen.dart';
import '../single_feed/single_feed_screen.dart';

class ProfileDetail extends StatelessWidget {
  final int index;
  ProfileDetail({Key? key, required this.index}) : super(key: key);
  final _controller = Get.find<SearchController>();
  final _profileRepo = Get.put(ProfileRepository());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return DefaultTabController(
      length: _controller.searchProfiles[index].status == 'VERIFIED' ? 2 : 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  GetBuilder<SearchController>(builder: (_) {
                    return FutureBuilder<ProfileModel>(
                        future: _profileRepo.getProfileById(
                            _controller.searchProfiles[index].id,
                            _controller.token!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Loading();
                          }
                          var profileModel = snapshot.data!;
                          return Stack(
                            children: [
                              Container(
                                height: Get.height * 0.2,
                                color: colorScheme.primaryContainer,
                              ),
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 100, bottom: 10),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            topRight: Radius.circular(40))),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                      ),
                                      child: Material(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: Get.height * 0.08,
                                            ),
                                            Text(
                                              profileModel
                                                  .user_profile!.fullname!,
                                              style: style.headline5,
                                            ),
                                            SizedBox(
                                              height: 80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: ListTile(
                                                    title: Text(
                                                        profileModel.reelCount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: style.headline6),
                                                    subtitle: Text(
                                                      "Rolls",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: style.titleMedium,
                                                    ),
                                                  )),
                                                  Expanded(
                                                      child: ListTile(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          ListUsersView(
                                                              0, profileModel));
                                                    },
                                                    title: Text(
                                                        profileModel
                                                            .followerCount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: style.headline6),
                                                    subtitle: Text("Followers",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            style.titleMedium),
                                                  )),
                                                  Expanded(
                                                      child: ListTile(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          ListUsersView(
                                                              1, profileModel));
                                                    },
                                                    title: Text(
                                                        profileModel
                                                            .followingCount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: style.headline6),
                                                    subtitle: Text("Followings",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            style.titleMedium),
                                                  )),
                                                ],
                                              ),
                                            ),
                                            FutureBuilder<bool>(
                                                future:
                                                    _profileRepo.isFollowing(
                                                        profileModel.id,
                                                        _controller.token!),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container();
                                                  }
                                                  return snapshot.data!
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 20,
                                                            vertical: 8,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _controller
                                                                        .toggleFollowing(
                                                                            index);
                                                                  },
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    minimumSize:
                                                                        const Size.fromHeight(
                                                                            50),
                                                                  ),
                                                                  child: Text(
                                                                    "Following",
                                                                    style: style
                                                                        .titleMedium,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: OutlinedButton.styleFrom(
                                                                      minimumSize:
                                                                          const Size.fromHeight(
                                                                              50)),
                                                                  child: Text(
                                                                    "Message",
                                                                    style: style
                                                                        .titleMedium,
                                                                  ),
                                                                ),
                                                              ))
                                                            ],
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      MyElevatedButton(
                                                                    buttonText:
                                                                        "Follow",
                                                                    onPressed:
                                                                        () {
                                                                      _controller
                                                                          .toggleFollowing(
                                                                              index);
                                                                    },
                                                                    height: 30,
                                                                    style: style
                                                                        .titleMedium,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: OutlinedButton.styleFrom(
                                                                      minimumSize:
                                                                          const Size.fromHeight(
                                                                              50)),
                                                                  child: Text(
                                                                    "Message",
                                                                    style: style
                                                                        .titleMedium,
                                                                  ),
                                                                ),
                                                              ))
                                                            ],
                                                          ),
                                                        );
                                                }),
                                            _controller.searchProfiles[index]
                                                        .status ==
                                                    'VERIFIED'
                                                ? Container(
                                                    width: Get.width * 0.9,
                                                    decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromRGBO(
                                                            255, 240, 218, 1),
                                                        border: Border.all(
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Column(
                                                        children: const [
                                                          Center(
                                                              child: Text(
                                                            "Upcoming giveaway on 18th June.",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 18),
                                                          )),
                                                          Center(
                                                              child: Text(
                                                            "Stay Tuned",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 18),
                                                          )),
                                                          Center(
                                                            child: Text(
                                                              "Engineer who love dancing, modelling, photography. DM me for collaboration",
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: Get.height * 0.08,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Material(
                                          elevation: 3,
                                          shape: CircleBorder(),
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                                "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        });
                  })
                ]),
              )
            ];
          },
          body: _tabSection(context, _controller.searchProfiles[index]),
        ),
      ),
    );
  }

  Widget _tabSection(BuildContext context, ProfileModel profileModel) {
    final _profileRepo = Get.find<ProfileRepository>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(tabs: [
          const Tab(text: "Rolls"),
          // const Tab(text: "Photos"),
          if (profileModel.status == 'VERIFIED') const Tab(text: "Giveaway"),
        ]),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: TabBarView(children: [
            ProfileReel(profileId: profileModel.id),
            // FutureBuilder<List<PhotoModel>>(
            //     future: _profileRepo.getPhotosByProfileId(
            //         profileModel.id, _controller.token!),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Loading();
            //       }
            //       if (snapshot.hasError) {
            //         printInfo(
            //             info: "getCurrentUserPhoto: ${snapshot.hasError}");
            //         return Container();
            //       }
            //       var photos = snapshot.data!;
            //       return photos.isEmpty
            //           ? const EmptyWidget("No photos available")
            //           : GridView.builder(
            //               shrinkWrap: true,
            //               physics: const NeverScrollableScrollPhysics(),
            //               itemCount: photos.length,
            //               gridDelegate:
            //                   const SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount: 3,
            //                 childAspectRatio: 1,
            //                 crossAxisSpacing: 5,
            //               ),
            //               itemBuilder: (context, index) {
            //                 String thumbnail = photos[index].videoId.url;
            //                 printInfo(
            //                     info: "ProfileId: ${_controller.profileId}");
            //                 printInfo(info: "tumbnail: $thumbnail");
            //                 return GestureDetector(
            //                   onTap: () {
            //                     Get.to(SingleFeedScreen(null, photos[index]));
            //                   },
            //                   child: CachedNetworkImage(
            //                     imageUrl: thumbnail,
            //                     fit: BoxFit.cover,
            //                     errorWidget: (c, s, e) =>
            //                         const Icon(Icons.error),
            //                   ),
            //                 );
            //               },
            //             );
            //     }),

            if (profileModel.status == 'VERIFIED')
              const Center(child: Text("Giveaway")),
          ]),
        ),
      ],
    );
  }
}

class ProfileReel extends StatelessWidget {
  final int? profileId;
  ProfileReel({Key? key, this.profileId}) : super(key: key);

  final _profileRepo = Get.find<ProfileRepository>();

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<SearchController>();
    return FutureBuilder<List<ReelModel>>(
        future: profileId != null
            ? _profileRepo.getReelByProfileId(profileId!, _controller.token!)
            : _profileRepo.getReelByProfileId(
                _controller.profileId!, _controller.token!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            printInfo(info: "profileReels: ${snapshot.error}");
          }
          var reels = snapshot.data!;
          if (reels.isEmpty) {
            return const Center(
              child: Text("No reels available"),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(SingleFeedScreen(reels, index));
                },
                child: CachedNetworkImage(
                  imageUrl: reels[index].thumbnail,
                  errorWidget: (context, a, b) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        });
  }
}
