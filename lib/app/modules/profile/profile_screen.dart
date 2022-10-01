// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/account_settings/views/account_settings_view.dart';
import 'package:reel_ro/app/modules/homepage/profile_detail_screen.dart';
import 'package:reel_ro/app/modules/list_users/list_users_view.dart';
import 'package:reel_ro/app/modules/profile/profile_photo_view.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/base.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/shimmer_animation.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/photo_model.dart';
import '../../../utils/empty_widget.dart';
import '../../../utils/snackbar.dart';
import '../add_feed/add_feed_screen.dart';
import '../add_feed/widgets/video_trimmer_view.dart';
import '../edit_profile/views/edit_profile_view.dart';
import '../list_users/list_users_controller.dart';
import '../single_feed/single_feed_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = Get.put(ProfileController());

  final authService = Get.put(AuthService());

  final _profileRepo = Get.put(ProfileRepository());
  var parser = EmojiParser();

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
                    color: Colors.black54,
                  ),
                  onPressed: () async {
                    Get.to(AccountSettingsView());
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_box_outlined,
                    color: Colors.black54,
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
                    //     // var video = await ImagePicker()
                    //     //     .pickVideo(source: ImageSource.gallery);
                    //     // if (video != null) {
                    //     //   Get.to(
                    //     //     () => AddFeedScreen(
                    //     //       file: File(video.path),
                    //     //       type: 0,
                    //     //     ),
                    //     //   );
                    //     // }
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
                    //   _controller.update();
                    // }

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
                          final val = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return VideoTrimmerView(File(video.path));
                            }),
                          );
                          if (val != null) {
                            log("VideoAdded: $val");
                            _controller.updateManually();
                          }
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
                    // var video = await ImagePicker()
                    //     .pickVideo(source: ImageSource.gallery);
                    // if (video != null) {
                    //   final val = await Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) {
                    //       return VideoTrimmerView(File(video.path));
                    //     }),
                    //   );
                    //   if (val != null) {
                    //     setState(() {});
                    //   }
                    // }
                  },
                ),
              ],
            ),
            body: StatefulBuilder(builder: (context, setState) {
              return FutureBuilder<ProfileModel>(
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
                                              Text(
                                                "@${profileModel.username!}",
                                                style: style.titleMedium,
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
                                                        "Rolls",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            style.titleMedium,
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: ListTile(
                                                      onTap: () {
                                                        Get.to(ListUsersView(
                                                            0, profileModel));
                                                      },
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
                                                      onTap: () {
                                                        Get.to(ListUsersView(
                                                            1, profileModel));
                                                      },
                                                      title: Text(
                                                          profileModel
                                                              .followingCount
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              style.headline6),
                                                      subtitle: Text(
                                                          "Following",
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
                                                    Get.to(EditProfileView(
                                                      profileEditCalBack: () {
                                                        setState(() {});
                                                      },
                                                    ));
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
                                              // if (profileModel.status ==
                                              //     "VERIFIED")
                                              Container(
                                                width: Get.width * 0.9,
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 240, 218, 1),
                                                    border: Border.all(
                                                      color: Colors.transparent,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                          child: Text(
                                                        "\"${parser.emojify(profileModel.user_profile!.bio!)}\"",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 18),
                                                      )),
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
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(ProfilePhotoView(
                                              'hero2',
                                              profileModel
                                                  .user_profile!.fullname!,
                                              "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}"));
                                        },
                                        child: Material(
                                          elevation: 3,
                                          shape: CircleBorder(),
                                          child: Hero(
                                            tag: "hero2",
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                  "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}"),
                                            ),
                                          ),
                                        ),
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
                },
              );
            })),
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(tabs: [
          Tab(text: "Rolls"),
          Tab(text: "Photos"),
          if (_controller.profileModel.status == 'VERIFIED')
            Tab(text: "Giveaway"),
        ]),
        Expanded(
          child: TabBarView(children: [
            ProfileReel(
              key: UniqueKey(),
            ),
            PhotoSection(
                id: _controller.profileModel.id, token: _controller.token!),
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
    return FutureBuilder<List<ReelModel>>(
      future: profileId != null
          ? _profileRepo.getReelByProfileId(profileId!, _controller.token!,
              limit: 50, skip: 0)
          : _profileRepo.getReelByProfileId(
              _controller.profileId!, _controller.token!,
              limit: 50, skip: 0),
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

        if (reels.isEmpty) {
          return Center(
            child: Text("No reels available"),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            if (index == (reels.length - 3) && !_controller.loadingMore) {
              _controller.getMoreFeed(reels.length);
              if (_controller.reelsLoaded.isNotEmpty) {
                reels.addAll(_controller.reelsLoaded);
                _controller.reelsLoaded.clear();
                _controller.update();
              }
            }
            var tumb = reels[index].thumbnail;

            return InkWell(
              onTap: () {
                Get.to(SingleFeedScreen(null, reels, index));
              },
              onLongPress: () {
                Get.dialog(AlertDialog(
                  title:
                      const Text("Are you sure you want to delete this roll?"),
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
              child: FutureBuilder<String>(
                future: _profileRepo.getThumbnail(reels[index].thumbnail),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ShimmerCardAnimation();
                  }

                  return CachedNetworkImage(
                    key: UniqueKey(),
                    errorWidget: (_, a, b) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        alignment: Alignment.center,
                        child: Text("Processing..."),
                      );
                    },
                    imageUrl: snapshot.data!,
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class PhotoSection extends StatelessWidget {
  final int id;
  final String token;
  PhotoSection({Key? key, required this.id, required this.token})
      : super(key: key);

  final _profileRepo = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<ProfileController>();
    return FutureBuilder<List<PhotoModel>>(
        future: _profileRepo.getPhotosByProfileId(id, token),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }
          if (snapshot.hasError) {
            printInfo(info: "getCurrentUserPhoto: ${snapshot.hasError}");
            return Container();
          }
          var photos = snapshot.data!;
          return photos.isEmpty
              ? const EmptyWidget("No photos available")
              : GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: photos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    // String thumbnail = photos[index].videoId.url;
                    // printInfo(
                    //     info: "ProfileId: ${_controller.profileId}");
                    // printInfo(info: "tumbnail: $thumbnail");
                    return GestureDetector(
                      onLongPress: () {
                        Get.dialog(AlertDialog(
                          title: const Text(
                              "Are you sure you want to delete this post?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("NO")),
                            MaterialButton(
                              onPressed: () {
                                Get.back();
                                _controller.deletePost(photos[index].id);
                              },
                              child: const Text("YES"),
                              color: Colors.red,
                            ),
                          ],
                        ));
                      },
                      onTap: () {
                        Get.to(SingleFeedScreen(
                          photos,
                          null,
                          index,
                          isPhoto: true,
                        ));
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                            "${Base.profileBucketUrl}/${photos[index].filename}",
                        fit: BoxFit.cover,
                        errorWidget: (c, s, e) => const Icon(Icons.error),
                      ),
                    );
                  },
                );
        });
  }
}
