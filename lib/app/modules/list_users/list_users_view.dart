// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/utils/base.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../utils/colors.dart';
import '../homepage/profile_detail_screen.dart';
import 'list_users_controller.dart';

class ListUsersView extends StatelessWidget {
  ListUsersView(this.initialIndex, this.profileModel, {Key? key})
      : super(key: key);

  final int initialIndex;
  final ProfileModel profileModel;

  final _controller = Get.put(ListUsersController());
  final _profileRepo = Get.put(ProfileRepository());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListUsersController>(
        builder: (_) => DefaultTabController(
              initialIndex: initialIndex,
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(profileModel.user_profile!.fullname!),
                  elevation: 0,
                  backgroundColor: Colors.grey[850],
                ),
                body: _tabSection(context),
              ),
            ));
  }

  Widget _tabSection(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(tabs: [
            Tab(
                child:
                    Text("Followers", style: TextStyle(color: Colors.white))),
            Tab(
                child: Text(
              "Following",
              style: TextStyle(color: Colors.white),
            )),
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
                    return Loading();
                  }
                  if (snapshot.hasError) {
                    printInfo(
                        info: "getFollowersByUserId: ${snapshot.hasError}");
                    return Container();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          if (snapshot.data![index].id !=
                              _controller.profileModel.id) {
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
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
                              fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        subtitle: Text(
                          snapshot.data![index].username!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: snapshot.data![index].id !=
                                  _controller.profileId
                              ? FutureBuilder<bool>(
                                  future: _profileRepo.isFollowing(
                                      snapshot.data![index].id,
                                      _controller.token!),
                                  builder: (context, snap) {
                                    return OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.grey[850]),
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
                                        style: style.caption!
                                            .copyWith(color: Colors.white),
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
                    return Loading();
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
                          if (snapshot.data![index].id !=
                              _controller.profileModel.id) {
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
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
                              fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        subtitle: Text(
                          snapshot.data![index].username!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: snapshot.data![index].id !=
                                  _controller.profileId
                              ? FutureBuilder<bool>(
                                  future: _profileRepo.isFollowing(
                                      snapshot.data![index].id,
                                      _controller.token!),
                                  builder: (context, snap) {
                                    return OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.grey[850]),
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
                                        style: style.caption!
                                            .copyWith(color: Colors.white),
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
      ),
    );
  }
}
