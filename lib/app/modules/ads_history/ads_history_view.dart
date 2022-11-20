import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/ads_history_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../single_feed/single_feed_screen.dart';
import 'ads_history_controller.dart';

class AdsHistoryView extends StatelessWidget {
  AdsHistoryView({Key? key}) : super(key: key);

  final _controller = Get.put(AdsHistoryController());
  final authService = Get.put(AuthService());
  final _profileRepo = Get.put(ProfileRepository());

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Ads History',
            style: style.titleMedium,
          ),
        ),
      ),
      body: GetBuilder<AdsHistoryController>(
          builder: (_) => FutureBuilder<List<AdsHistoryModel>>(
              future: _controller.profileId != null
                  ? _profileRepo.getAdsHistoryByProfileId(
                      _controller.profileId!, _controller.token!)
                  : _profileRepo.getAdsHistoryByProfileId(
                      _controller.profileId!, _controller.token!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                }
                if (snapshot.hasError) {
                  printInfo(info: "profileReels: ${snapshot.error}");
                }
                var ads = snapshot.data!;
                if (ads.isEmpty) {
                  return const Center(
                    child: Text("No Ads History Available"),
                  );
                }
                log("Ads: ${snapshot.data}");
                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ads.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    log("Add Tumb: ${ads[index].ads.thumbnail}");
                    return GestureDetector(
                        onTap: () {
                          Get.to(SingleFeedScreen(
                              null,
                              ads
                                  .map((e) => ReelModel(
                                      id: e.ads.id,
                                      video_title: e.ads.video_title,
                                      description: e.ads.description,
                                      filename: e.ads.filename,
                                      filepath: e.ads.filepath,
                                      media_ext: e.ads.media_ext,
                                      thumbnail: e.ads.thumbnail,
                                      user: e.ads.user))
                                  .toList(),
                              index));
                        },
                        child: FutureBuilder<String>(
                          future: _profileRepo
                              .getThumbnail(ads[index].ads.thumbnail),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return CachedNetworkImage(
                              key: UniqueKey(),
                              placeholder: (context, url) {
                                return IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.refresh_rounded));
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
                        ));
                  },
                );
              })),
    );
  }
}
