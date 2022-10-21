import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/homepage/profile_detail_screen.dart';
import 'package:reel_ro/app/modules/single_feed/single_feed_screen.dart';
import 'package:reel_ro/models/notification_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/repositories/notification_repository.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/constants.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/widgets/loading.dart';

import '../utils/base.dart';
import '../utils/colors.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final _notificationRepo = Get.put(NotificationRepository());
  final _controller = Get.put(NotificationController());
  final _profileRepo = Get.find<ProfileRepository>();
  final _reelRepo = Get.find<ReelRepository>();
  final token = Get.find<AuthService>().token;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                )),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: Text(
              "Notification",
              style: style.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          body: FutureBuilder<List<NotificationModel>>(
              future: _notificationRepo.getNotificationList(token!),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Loading();
                }
                var notifications = snap.data!;
                log("Notification: $notifications");
                return notifications.isEmpty
                    ? const EmptyWidget("No notifications available!")
                    : ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16.0),
                        children: notifications.map(
                          (e) {
                            if (e.data.notificationType ==
                                NotificationType.follow) {
                              return GetBuilder<NotificationController>(
                                  builder: (_) => NotificationTile(
                                        userId: e.data.userId,
                                        title: e.title,
                                        subTile: e.body,
                                        traiing: FutureBuilder<bool>(
                                          future: _profileRepo.isFollowing(
                                              e.data.userId, token!),
                                          builder: (context, snap) {
                                            return snap.hasData
                                                ? snap.data!
                                                    ? OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white54,
                                                        ),
                                                        onPressed: () {
                                                          Get.dialog(
                                                              AlertDialog(
                                                            backgroundColor:
                                                                Colors.black54,
                                                            title: snap.data!
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
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child: const Text(
                                                                      "Cancel")),
                                                              MaterialButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                  _controller
                                                                      .toggleFollowing(e
                                                                          .data
                                                                          .userId);
                                                                },
                                                                child: const Text(
                                                                    "Confirm"),
                                                                color: AppColors
                                                                    .buttonColor,
                                                              ),
                                                            ],
                                                          ));
                                                        },
                                                        child: Text(
                                                          "Following",
                                                          style: style.caption!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      )
                                                    : MaterialButton(
                                                        onPressed: () {
                                                          Get.dialog(
                                                              AlertDialog(
                                                            backgroundColor:
                                                                Colors.black54,
                                                            title: snap.data!
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
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child: const Text(
                                                                      "Cancel")),
                                                              MaterialButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                  _controller
                                                                      .toggleFollowing(e
                                                                          .data
                                                                          .userId);
                                                                },
                                                                child: const Text(
                                                                    "Confirm"),
                                                                color: AppColors
                                                                    .buttonColor,
                                                              ),
                                                            ],
                                                          ));
                                                        },
                                                        color:
                                                            colorSchema.primary,
                                                        shape:
                                                            const StadiumBorder(),
                                                        child: const Text(
                                                            "Follow"),
                                                      )
                                                : const SizedBox();
                                          },
                                        ),
                                      ));
                            } else if (e.data.notificationType ==
                                NotificationType.response) {
                              return NotificationTile(
                                title: e.title,
                                subTile: e.body,
                                userId: e.data.userId,
                                traiing: FutureBuilder<ReelModel>(
                                  future: _reelRepo.getReelByCommentId(
                                      e.data.entityId, token!),
                                  builder: (context, s) {
                                    debugPrint(
                                        '212121 comment response ${s.hasData}');
                                    if (!s.hasData) {
                                      log("single feed error: ${s.error}");
                                      return const SizedBox();
                                    }

                                    var reel = s.data!;
                                    log("tumbnail: ${reel.thumbnail}");
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => SingleFeedScreen(
                                              null,
                                              [reel],
                                              0,
                                              openComment: true,
                                            ));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: FutureBuilder<String>(
                                          future: _profileRepo
                                              .getThumbnail(reel.thumbnail),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return CircularProgressIndicator();
                                            }

                                            return CachedNetworkImage(
                                              key: UniqueKey(),
                                              placeholder: (context, url) {
                                                return IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                        Icons.refresh_rounded));
                                              },
                                              errorWidget: (_, a, b) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Loading(),
                                                );
                                              },
                                              imageUrl: snapshot.data!,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (e.data.notificationType ==
                                NotificationType.like) {
                              return NotificationTile(
                                  title: e.title,
                                  subTile: e.body,
                                  userId: e.data.userId,
                                  traiing: FutureBuilder<ReelModel>(
                                    future: _reelRepo.getSingleReel(
                                        e.data.entityId, token!),
                                    builder: (context, s) {
                                      if (!s.hasData) {
                                        log("single feed error: ${s.error}");
                                        return const SizedBox();
                                      }

                                      var reel = s.data!;
                                      log("tumbnail: ${reel.thumbnail}");
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => SingleFeedScreen(
                                              null, [reel], 0));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FutureBuilder<String>(
                                            future: _profileRepo
                                                .getThumbnail(reel.thumbnail),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator();
                                              }

                                              return CachedNetworkImage(
                                                key: UniqueKey(),
                                                placeholder: (context, url) {
                                                  return IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons
                                                          .refresh_rounded));
                                                },
                                                errorWidget: (_, a, b) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Loading(),
                                                  );
                                                },
                                                imageUrl: snapshot.data!,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ));
                            } else if (e.data.notificationType ==
                                NotificationType.comment) {
                              return NotificationTile(
                                  title: e.title,
                                  subTile: e.body,
                                  userId: e.data.userId,
                                  traiing: FutureBuilder<ReelModel>(
                                    future: _reelRepo.getSingleReel(
                                        e.data.entityId, token!),
                                    builder: (context, s) {
                                      if (!s.hasData) {
                                        log("single feed error: ${s.error}");
                                        return const SizedBox();
                                      }

                                      var reel = s.data!;
                                      log("tumbnail: ${reel.thumbnail}");
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => SingleFeedScreen(
                                                null,
                                                [reel],
                                                0,
                                                openComment: true,
                                              ));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FutureBuilder<String>(
                                            future: _profileRepo
                                                .getThumbnail(reel.thumbnail),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator();
                                              }

                                              return CachedNetworkImage(
                                                key: UniqueKey(),
                                                placeholder: (context, url) {
                                                  return IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons
                                                          .refresh_rounded));
                                                },
                                                errorWidget: (_, a, b) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Loading(),
                                                  );
                                                },
                                                imageUrl: snapshot.data!,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ));
                            } else {
                              return NotificationTile(
                                  userId: e.data.userId,
                                  title: e.title,
                                  subTile: e.body,
                                  traiing: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
                                    ),
                                  ));
                            }
                          },
                        ).toList(),
                      );
              })),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Widget traiing;
  final String title;
  final String subTile;
  final int userId;
  NotificationTile(
      {Key? key,
      required this.traiing,
      required this.title,
      required this.userId,
      required this.subTile})
      : super(key: key);

  final _profileRepo = Get.find<ProfileRepository>();
  final token = Get.find<AuthService>().token!;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: FutureBuilder<ProfileModel>(
            future: _profileRepo.getProfileById(userId, token),
            builder: (context, s) {
              if (!s.hasData) {
                return const SizedBox();
              }
              var profile = s.data!;
              return InkWell(
                onTap: () {
                  Get.to(
                    () => ProfileDetail(
                      profileModel: profile,
                      onBack: () {
                        Get.back();
                      },
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: colorSchema.primary,
                  backgroundImage: NetworkImage(
                    "${Base.profileBucketUrl}/${profile.user_profile!.profile_img}",
                  ),
                ),
              );
            }),
        title: Text(
          title,
          style: style.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subTile,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
        trailing: traiing);
  }
}

class NotificationController extends GetxController {
  final _profileRepo = Get.find<ProfileRepository>();
  final token = Get.find<AuthService>().token;

  void toggleFollowing(int userId) async {
    try {
      _profileRepo.toggleFollow(userId, token!);
      update();
    } catch (e) {
      log("toggleFollowingError: $e");
    }
  }

  void updateMannual() {
    update();
  }
}
