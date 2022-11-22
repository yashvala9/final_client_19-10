import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/auth_controller.dart';
import 'package:reel_ro/app/modules/homepage/profile_detail_screen.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';
import '../../../services/communication_services.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../widgets/my_elevated_button.dart';
import '../chat/chat_view.dart';
import '../list_users/list_users_view.dart';
import '../single_feed/single_feed_screen.dart';

class OtherProfileDetail extends StatefulWidget {
  final ProfileModel profileModel;
  const OtherProfileDetail({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<OtherProfileDetail> createState() => _OtherProfileDetailState();
}

class _OtherProfileDetailState extends State<OtherProfileDetail> {
  final _profileRepo = Get.put(ProfileRepository());
  final _authService = Get.find<AuthService>();
  final parser = EmojiParser();

  void toggleFollowing(int profileId, String token) async {
    try {
      _profileRepo.toggleFollow(profileId, token);
      setState(() {});
    } catch (e) {
      log("toggleFollowingError: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final CommunicationService _communicationService = CommunicationService.to;
    return DefaultTabController(
      length: widget.profileModel.status == 'VERIFIED' ? 3 : 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  GetBuilder<AuthController>(builder: (_) {
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
                              margin:
                                  const EdgeInsets.only(top: 100, bottom: 10),
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
                                        widget.profileModel.user_profile!
                                            .fullname!,
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
                                                  widget.profileModel.reelCount
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: style.headline6),
                                              subtitle: Text(
                                                "Reels",
                                                textAlign: TextAlign.center,
                                                style: style.titleMedium,
                                              ),
                                            )),
                                            Expanded(
                                                child: ListTile(
                                              onTap: () {
                                                Get.to(ListUsersView(
                                                    0, widget.profileModel));
                                              },
                                              title: Text(
                                                  widget.profileModel
                                                      .followerCount
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: style.headline6),
                                              subtitle: Text("Followers",
                                                  textAlign: TextAlign.center,
                                                  style: style.titleMedium),
                                            )),
                                            Expanded(
                                                child: ListTile(
                                              onTap: () {
                                                Get.to(ListUsersView(
                                                    1, widget.profileModel));
                                              },
                                              title: Text(
                                                  widget.profileModel
                                                      .followingCount
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: style.headline6),
                                              subtitle: Text("Following",
                                                  textAlign: TextAlign.center,
                                                  style: style.titleMedium),
                                            )),
                                          ],
                                        ),
                                      ),
                                      FutureBuilder<bool>(
                                          future: _profileRepo.isFollowing(
                                              widget.profileModel.id,
                                              _authService.token!),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            }
                                            return snapshot.data!
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                      vertical: 8,
                                                    ),
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        Get.dialog(AlertDialog(
                                                          backgroundColor:
                                                              Colors.black54,
                                                          title: snapshot.data!
                                                              ? const Text(
                                                                  "Do you wish to unfollow?",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              : const Text(
                                                                  "Do you wish to follow?",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: const Text(
                                                                    "Cancel")),
                                                            MaterialButton(
                                                              onPressed: () {
                                                                Get.back();
                                                                toggleFollowing(
                                                                    widget
                                                                        .profileModel
                                                                        .id,
                                                                    _authService
                                                                        .token!);
                                                              },
                                                              child: const Text(
                                                                  "Confirm"),
                                                              color: AppColors
                                                                  .buttonColor,
                                                            ),
                                                          ],
                                                        ));
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        minimumSize: const Size
                                                            .fromHeight(50),
                                                      ),
                                                      child: Text(
                                                        "Following",
                                                        style:
                                                            style.titleMedium,
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                MyElevatedButton(
                                                              buttonText:
                                                                  "Follow",
                                                              onPressed: () {
                                                                Get.dialog(
                                                                    AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black54,
                                                                  title:
                                                                      const Text(
                                                                    "Do you wish to follow?",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
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
                                                                        child: const Text(
                                                                            "Cancel")),
                                                                    MaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                        toggleFollowing(
                                                                            widget.profileModel.id,
                                                                            _authService.token!);
                                                                      },
                                                                      child: const Text(
                                                                          "Confirm"),
                                                                      color: AppColors
                                                                          .buttonColor,
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
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              log("aaaaaaaaaaaaaaaaa");

                                                              log("State: ${_communicationService.client.state}");
                                                              log("CurrentUser: ${_communicationService.client.state.currentUser}");
                                                              String
                                                                  newChannelId =
                                                                  '${widget.profileModel.id}${_communicationService.client.state.currentUser!.id}';

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
                                                                  'members': [
                                                                    widget
                                                                        .profileModel
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
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return ChannelPage(
                                                                  channel:
                                                                      _newChannel,
                                                                );
                                                              }));
                                                            },
                                                            style: OutlinedButton
                                                                .styleFrom(
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
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: Text(
                                                parser.emojify(widget
                                                    .profileModel
                                                    .user_profile!
                                                    .bio!),
                                                style: const TextStyle(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Material(
                                    elevation: 3,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          AssetImage(Assets.profile),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  })
                ]),
              )
            ];
          },
          body: _tabSection(context, widget.profileModel, _authService.token!),
        ),
      ),
    );
  }

  Widget _tabSection(
      BuildContext context, ProfileModel profileModel, String token) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(tabs: [
          const Tab(text: "Rolls"),
          const Tab(text: "Photos"),
          if (profileModel.status == 'VERIFIED') const Tab(text: "Giveaway"),
        ]),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: TabBarView(children: [
            ProfileReel(profileId: profileModel.id),
            PhotoSection(id: profileModel.id, token: token),
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
                  Get.to(SingleFeedScreen(null, reels, index, () {}));
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
