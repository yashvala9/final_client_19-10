import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/homepage/profile_detail_screen.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/widgets/shimmer_animation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../models/photo_model.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';
import '../../../services/communication_services.dart';
import '../../../utils/assets.dart';
import '../../../utils/base.dart';
import '../../../utils/colors.dart';
import '../../../utils/empty_widget.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/my_elevated_button.dart';
import '../chat/chat_view.dart';
import '../list_users/list_users_view.dart';
import '../profile/profile_photo_view.dart';
import '../profile/profile_screen.dart';
import '../single_feed/single_feed_screen.dart';

class ProfileDetail extends StatelessWidget {
  final int index;
  ProfileDetail({Key? key, required this.index}) : super(key: key);
  final _controller = Get.find<SearchController>();
  final _profileRepo = Get.put(ProfileRepository());

  final CommunicationService _communicationService = CommunicationService.to;
  var parser = EmojiParser();
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return DefaultTabController(
      length: _controller.searchProfiles[index].status == 'VERIFIED' ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
            onPressed: () async {
              Get.back();
            },
          ),
        ),
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
                                                    subtitle: Text("Following",
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
                                                                    Get.dialog(
                                                                        AlertDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black54,
                                                                      title: snapshot
                                                                              .data!
                                                                          ? const Text(
                                                                              "Do you wish to unfollow?",
                                                                              style: TextStyle(color: Colors.white),
                                                                            )
                                                                          : const Text(
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
                                                                            _controller.toggleFollowing(index);
                                                                          },
                                                                          child:
                                                                              const Text("Confirm"),
                                                                          color:
                                                                              AppColors.buttonColor,
                                                                        ),
                                                                      ],
                                                                    ));
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
                                                                      () {
                                                                    log("aaaaaaaaaaaaaaaaa");

                                                                    log("State: ${_communicationService.client.state}");
                                                                    log("CurrentUser: ${_communicationService.client.state.currentUser}");
                                                                    String
                                                                        queryId =
                                                                        '${_communicationService.client.state.currentUser!.id.hashCode}${profileModel.id.hashCode}';
                                                                    String
                                                                        newChannelId =
                                                                        '${profileModel.id}${_communicationService.client.state.currentUser!.id}';

                                                                    final Channel
                                                                        _newChannel =
                                                                        _communicationService
                                                                            .client
                                                                            .channel(
                                                                      'messaging',
                                                                      id: newChannelId,
                                                                      extraData: {
                                                                        'isGroupChat':
                                                                            false,
                                                                        'presence':
                                                                            true,
                                                                        'members':
                                                                            [
                                                                          profileModel
                                                                              .id
                                                                              .toString(),
                                                                          _communicationService
                                                                              .client
                                                                              .state
                                                                              .currentUser!
                                                                              .id
                                                                              .toString(),
                                                                        ],
                                                                      },
                                                                    );
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return ChannelPage(
                                                                        channel:
                                                                            _newChannel,
                                                                      );
                                                                    }));
                                                                  },
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
                                                                      Get.dialog(
                                                                          AlertDialog(
                                                                        backgroundColor:
                                                                            Colors.black54,
                                                                        title: snapshot.data!
                                                                            ? const Text(
                                                                                "Do you wish to unfollow?",
                                                                                style: TextStyle(color: Colors.white),
                                                                              )
                                                                            : const Text(
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
                                                                              _controller.toggleFollowing(index);
                                                                            },
                                                                            child:
                                                                                const Text("Confirm"),
                                                                            color:
                                                                                AppColors.buttonColor,
                                                                          ),
                                                                        ],
                                                                      ));
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
                                                                      () async {
                                                                    log("aaaaaaaaaaaaaaaaa");

                                                                    log("State: ${_communicationService.client.state}");
                                                                    log("CurrentUser: ${_communicationService.client.state.currentUser}");
                                                                    String
                                                                        queryId =
                                                                        '${_communicationService.client.state.currentUser!.id.hashCode}${profileModel.id.hashCode}';
                                                                    String
                                                                        newChannelId =
                                                                        '${profileModel.id}${_communicationService.client.state.currentUser!.id}';

                                                                    final Channel
                                                                        _newChannel =
                                                                        _communicationService
                                                                            .client
                                                                            .channel(
                                                                      'messaging',
                                                                      id: newChannelId,
                                                                      extraData: {
                                                                        'isGroupChat':
                                                                            false,
                                                                        'presence':
                                                                            true,
                                                                        'members':
                                                                            [
                                                                          profileModel
                                                                              .id
                                                                              .toString(),
                                                                          _communicationService
                                                                              .client
                                                                              .state
                                                                              .currentUser!
                                                                              .id
                                                                              .toString(),
                                                                        ],
                                                                      },
                                                                    );
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return ChannelPage(
                                                                        channel:
                                                                            _newChannel,
                                                                      );
                                                                    }));
                                                                  },
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
                                            Container(
                                              width: Get.width * 0.9,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      255, 240, 218, 1),
                                                  border: Border.all(
                                                    color: Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                      parser.emojify(
                                                          profileModel
                                                              .user_profile!
                                                              .bio!),
                                                      style: TextStyle(
                                                          color: Colors.black,
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(ProfilePhotoView(
                                                'hero3',
                                                profileModel
                                                    .user_profile!.fullname!,
                                                "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}"));
                                          },
                                          child: Material(
                                            elevation: 3,
                                            shape: CircleBorder(),
                                            child: Hero(
                                              tag: "hero3",
                                              child: CircleAvatar(
                                                radius: 40,
                                                backgroundImage: NetworkImage(
                                                    "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}"),
                                              ),
                                            ),
                                          ),
                                        )
                                        // Material(
                                        //   elevation: 3,
                                        //   shape: CircleBorder(),
                                        //   child: CircleAvatar(
                                        //     radius: 40,
                                        //     backgroundImage: NetworkImage(
                                        //         "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}"),
                                        //   ),
                                        // ),
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
          const Tab(text: "Photos"),
          if (profileModel.status == 'VERIFIED') const Tab(text: "Giveaway"),
        ]),
        Expanded(
          child: TabBarView(children: [
            ProfileReel(profileId: profileModel.id),
            PhotoSection(id: profileModel.id, token: _controller.token!),
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
  final _reelRepo = Get.find<ReelRepository>();

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
            return const Loading();
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
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(SingleFeedScreen([], reels, index));
                },
                child: Stack(children: [
                  FutureBuilder<String>(
                    future: _profileRepo.getThumbnail(reels[index].thumbnail),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ShimmerCardAnimation();
                      }

                      return SizedBox(
                        width: double.infinity,
                        child: CachedNetworkImage(
                          key: UniqueKey(),
                          errorWidget: (_, a, b) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              alignment: Alignment.center,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          imageUrl: snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  FutureBuilder<int>(
                    future: _reelRepo.getReelViews(
                        reels[index].id.toString(), _controller.token!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ShimmerCardAnimation();
                      }

                      return Positioned(
                          bottom: 5,
                          left: 5,
                          child: Row(
                            children: [
                              Icon(Icons.play_arrow, color: Colors.white),
                              Text(
                                snapshot.data.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ));
                    },
                  ),
                ]),
              );
            },
          );
        });
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
                    return GestureDetector(
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
