// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/account_settings/views/account_settings_view.dart';
import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/base.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/assets.dart';
import '../edit_profile/views/edit_profile_view.dart';
import '../single_feed/single_feed_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final _controller = Get.put(ProfileController());
  final authService = Get.put(AuthService());
  final _profileRepo = Get.put(ProfileRepository());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return GetBuilder<ProfileController>(
      builder: (_) => DefaultTabController(
        length: _controller.profileModel.status == "VERIFIED" ? 3 : 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                  ),
                  onPressed: () async {
                    Get.to(AccountSettingsView());
                  },
                ),
              ],
            ),
            body: FutureBuilder<ProfileModel>(
                future: _profileRepo.getUserProfile(_controller.token!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Loading();
                  }
                  var profileModel = snapshot.data!;
                  return NestedScrollView(
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Stack(
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
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40))),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
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
                                                          style:
                                                              style.headline6),
                                                      subtitle: Text(
                                                        "Reels",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            style.titleMedium,
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: ListTile(
                                                      title: Text(
                                                          profileModel
                                                              .followerCount
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              style.headline6),
                                                      subtitle: Text(
                                                          "Followers",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: style
                                                              .titleMedium),
                                                    )),
                                                    Expanded(
                                                        child: ListTile(
                                                      onTap: () {},
                                                      title: Text(
                                                          profileModel
                                                              .followingCount
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              style.headline6),
                                                      subtitle: Text(
                                                          "Followings",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: style
                                                              .titleMedium),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 8,
                                                ),
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Get.to(EditProfileView());
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    minimumSize:
                                                        Size.fromHeight(40),
                                                  ),
                                                  child: Text(
                                                    "Edit Profile",
                                                    style: style.titleMedium,
                                                  ),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding:
                                              //       const EdgeInsets.all(8.0),
                                              //   child: Row(
                                              //     children: [
                                              //       Expanded(
                                              //         child: Padding(
                                              //           padding:
                                              //               const EdgeInsets.all(
                                              //                   8.0),
                                              //           child: MyElevatedButton(
                                              //             buttonText: "Follow",
                                              //             onPressed: () {
                                              //               _controller.signOut();
                                              //               authService
                                              //                   .redirectUser();
                                              //             },
                                              //             height: 30,
                                              //             style:
                                              //                 style.titleMedium,
                                              //           ),
                                              //         ),
                                              //       ),
                                              //       Expanded(
                                              //           child: Padding(
                                              //         padding:
                                              //             const EdgeInsets.all(
                                              //                 8.0),
                                              //         child: OutlinedButton(
                                              //           onPressed: () {},
                                              //           style: OutlinedButton
                                              //               .styleFrom(
                                              //                   minimumSize: Size
                                              //                       .fromHeight(
                                              //                           50)),
                                              //           child: Text(
                                              //             "Message",
                                              //             style:
                                              //                 style.titleMedium,
                                              //           ),
                                              //         ),
                                              //       ))
                                              //     ],
                                              //   ),
                                              // ),
                                              if (profileModel.status ==
                                                  "VERIFIED")
                                                Container(
                                                  width: Get.width * 0.9,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          255, 240, 218, 1),
                                                      border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                            child: Text(
                                                          "Upcoming giveaway on 18th June.",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18),
                                                        )),
                                                        Center(
                                                            child: Text(
                                                          "Stay Tuned",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18),
                                                        )),
                                                        Center(
                                                          child: Text(
                                                            "Engineer who love dancing, modelling, photography. DM me for collaboration",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
                            )
                          ]),
                        )
                      ];
                    },
                    body: _tabSection(context),
                  );
                })),
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(tabs: [
          Tab(text: "Rolls"),
          Tab(text: "Photos"),
          if (_controller.profileModel.status == 'VERIFIED')
            Tab(text: "Giveaway"),
        ]),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: TabBarView(children: [
            ProfileReel(),
            Container(),
            // FutureBuilder<List<PhotoModel>>(
            //     future: _profileRepo.getPhotosByProfileId(
            //         _controller.profileId!, _controller.token!),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return Loading();
            //       }
            //       if (snapshot.hasError) {
            //         printInfo(
            //             info: "getCurrentUserPhoto: ${snapshot.hasError}");
            //         return Container();
            //       }
            //       var photos = snapshot.data!;
            //       return photos.isEmpty
            //           ? EmptyWidget("No photos available")
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
            //                     errorWidget: (c, s, e) => Icon(Icons.error),
            //                   ),
            //                 );
            //               },
            //             );
            //     }),
            if (_controller.profileModel.status == 'VERIFIED')
              Center(child: Text("Giveaway")),
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
  final _controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    printInfo(info: "ProfileId: ${_controller.profileId}");

    return FutureBuilder<List<ReelModel>>(
        future: profileId != null
            ? _profileRepo.getReelByProfileId(profileId!, _controller.token!)
            : _profileRepo.getReelByProfileId(
                _controller.profileId!, _controller.token!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            printInfo(info: "profileReels: ${snapshot.error}");
          }
          var reels = snapshot.data!;
          printInfo(info: "Reels: $reels");
          if (reels.isEmpty) {
            return Center(
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
                  Get.to(SingleFeedScreen(reels[index], null));
                },
                onLongPress: () {
                  Get.dialog(AlertDialog(
                    title: const Text(
                        "Are you sure you want to delete this roll?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("NO")),
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                          _controller.deleteReel(reels[index].id);
                        },
                        child: const Text("YES"),
                        color: Colors.red,
                      ),
                    ],
                  ));
                },
                child: CachedNetworkImage(
                  imageUrl:
                      "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        });
  }
}
