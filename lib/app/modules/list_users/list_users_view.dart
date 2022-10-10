// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/account_settings/views/account_settings_view.dart';
import 'package:reel_ro/app/modules/profile/profile_photo_view.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/base.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../utils/colors.dart';
import '../add_feed/add_feed_screen.dart';
import '../add_feed/widgets/video_trimmer_view.dart';
import '../edit_profile/views/edit_profile_view.dart';
import '../homepage/profile_detail_screen.dart';
import '../single_feed/single_feed_screen.dart';
import 'list_users_controller.dart';

class ListUsersView extends StatelessWidget {
  ListUsersView(this.initialIndex, this.profileModel, {Key? key})
      : super(key: key);

  int initialIndex;
  ProfileModel profileModel;

  final _controller = Get.put(ListUsersController());
  final _profileRepo = Get.put(ProfileRepository());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return GetBuilder<ListUsersController>(
        builder: (_) => DefaultTabController(
              initialIndex: initialIndex,
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text('@' + profileModel.username!),
                  elevation: 0,
                ),
                body: _tabSection(context),
              ),
            ));
  }

  Widget _tabSection(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(tabs: [
          Tab(text: "Followers"),
          Tab(text: "Following"),
        ]),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: TabBarView(children: [
            FutureBuilder<List<ProfileModel>>(
              future: _profileRepo.getFollowersByUserId(
                  profileModel.id, _controller.token!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Loading();
                }
                if (snapshot.hasError) {
                  printInfo(info: "getFollowersByUserId: ${snapshot.hasError}");
                  return Container();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Get.to(
                          ProfileDetail(
                            profileModel: snapshot.data![index],
                            onBack: () {
                              Get.back();
                            },
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.colorScheme.primary,
                        backgroundImage: NetworkImage(
                          snapshot.data![index].user_profile != null
                              ? "${Base.profileBucketUrl}/${snapshot.data![index].user_profile!.profile_img}"
                              : "",
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
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: snapshot.data![index].id != _controller.profileId
                            ? FutureBuilder<bool>(
                                future: _profileRepo.isFollowing(
                                    snapshot.data![index].id,
                                    _controller.token!),
                                builder: (context, snap) {
                                  return OutlinedButton(
                                    onPressed: () {
                                      Get.dialog(AlertDialog(
                                        backgroundColor: Colors.black54,
                                        title: snap.data!
                                            ? const Text(
                                                "Do you wish to unfollow?",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const Text(
                                                "Do you wish to follow?",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                            onPressed: () {
                                              Get.back();
                                              _controller.toggleFollowing(
                                                  snapshot.data![index].id);
                                            },
                                            child: const Text("Confirm"),
                                            color: AppColors.buttonColor,
                                          ),
                                        ],
                                      ));
                                    },
                                    child: Text(
                                      snap.hasData
                                          ? snap.data!
                                              ? "Following"
                                              : "Follow"
                                          : "",
                                      style: style.caption,
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                      ),
                    );
                  },
                );
              },
            ),
            FutureBuilder<List<ProfileModel>>(
              future: _profileRepo.getFollowingsByUserId(
                  profileModel.id, _controller.token!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Loading();
                }
                if (snapshot.hasError) {
                  printInfo(
                      info: "getFollowingsByUserId: ${snapshot.hasError}");
                  return Container();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Get.to(
                          ProfileDetail(
                            profileModel: snapshot.data![index],
                            onBack: () {
                              Get.back();
                            },
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.colorScheme.primary,
                        backgroundImage: NetworkImage(
                          snapshot.data![index].user_profile != null
                              ? "${Base.profileBucketUrl}/${snapshot.data![index].user_profile!.profile_img}"
                              : "",
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
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: snapshot.data![index].id != _controller.profileId
                            ? FutureBuilder<bool>(
                                future: _profileRepo.isFollowing(
                                    snapshot.data![index].id,
                                    _controller.token!),
                                builder: (context, snap) {
                                  return OutlinedButton(
                                    onPressed: () {
                                      Get.dialog(AlertDialog(
                                        backgroundColor: Colors.black54,
                                        title: snap.data!
                                            ? const Text(
                                                "Do you wish to unfollow?",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const Text(
                                                "Do you wish to follow?",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                            onPressed: () {
                                              Get.back();
                                              _controller.toggleFollowing(
                                                  snapshot.data![index].id);
                                            },
                                            child: const Text("Confirm"),
                                            color: AppColors.buttonColor,
                                          ),
                                        ],
                                      ));
                                    },
                                    child: Text(
                                      snap.hasData
                                          ? snap.data!
                                              ? "Following"
                                              : "Follow"
                                          : "",
                                      style: style.caption,
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                      ),
                    );
                  },
                );
              },
            )
          ]),
        ),
      ],
    );
  }
}
