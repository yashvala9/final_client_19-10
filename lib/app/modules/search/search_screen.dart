import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/app/modules/search/widget/search_tile.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/chart_tile.dart';

import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';
import '../../../repositories/reel_repository.dart';
import '../../../services/auth_service.dart';
import '../../../utils/assets.dart';
import '../../../widgets/loading.dart';
import '../profile/profile_controller.dart';
import '../single_feed/single_feed_screen.dart';
import 'widget/search_tag_tile.dart';

// class Debouncer {
//   final int milliseconds;
//   Timer? _timer;

//   Debouncer({required this.milliseconds});

//   run(VoidCallback action) {
//     _timer?.cancel();
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }

final _controller = Get.put(SearchController());

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final _reelRepo = Get.put(ReelRepository());
  final _profileRepo = Get.find<ProfileRepository>();

  // final searchTextController = TextEditingController();
  // final _debounce = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Text(
                  "Search",
                  style: style.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: "Search here..."),
                // controller: searchTextController,
                onFieldSubmitted: (value) {
                  // _debounce.run(() {
                  if (value.trim().isEmpty) {
                    showSnackBar("Search is empty", color: Colors.red);
                    return;
                  }
                  if (value.startsWith('#')) {
                    value.replaceAll('#', '');
                    Get.to(SearchHashTags(
                      hashTag: value.trim(),
                    ));
                  } else {
                    Get.to(
                      () => SearchUsers(
                        username: value.trim(),
                      ),
                    );
                  }
                  // });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder<List<ReelModel>>(
                  future: _reelRepo.getFeedsWithAds(
                      _controller.profileId!, _controller.token!,
                      limit: 24, skip: 0),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      printInfo(info: "profileReels: ${snapshot.error}");
                    }
                    var reels = snapshot.data;
                    if (reels!.isEmpty) {
                      return const Center(
                        child: Text("No reels available"),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reels.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        if (index == (reels.length - 3) &&
                            !_controller.loadingMore) {
                          _controller.getMoreFeed(reels.length);
                          if (_controller.reelList.isNotEmpty) {
                            reels.addAll(_controller.reelList);
                            _controller.reelList.clear();
                            _controller.update();
                          }
                        }
                        return GestureDetector(
                            onTap: () {
                              Get.to(SingleFeedScreen(reels, index));
                            },
                            child: FutureBuilder<String>(
                              future: _profileRepo
                                  .getThumbnail(reels[index].thumbnail),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return CachedNetworkImage(
                                  key: UniqueKey(),
                                  placeholder: (context, url) {
                                    return IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.refresh_rounded));
                                  },
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
                            ));
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class SearchUsers extends StatelessWidget {
  final String username;
  const SearchUsers({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    _controller.searchUser(username);
    return GetBuilder<SearchController>(
      builder: (_) => SafeArea(
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Text(
                  "Search",
                  style: style.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: _controller.loading
                    ? const Loading()
                    : _controller.searchProfiles.isEmpty
                        ? const EmptyWidget("No details found")
                        : ListView(
                            shrinkWrap: true,
                            children: List.generate(
                              _controller.searchProfiles.length,
                              (index) => SearchTile(index: index),
                            ).toList(),
                          ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class SearchHashTags extends StatelessWidget {
  final String hashTag;
  const SearchHashTags({Key? key, required this.hashTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    _controller.getReelsByHashTag(hashTag);
    return GetBuilder<SearchController>(
      builder: (_) => SafeArea(
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Text(
                  "Search",
                  style: style.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: _controller.loading
                    ? const Loading()
                    : _controller.searchReels.isEmpty
                        ? const EmptyWidget("No details found")
                        : ListView(
                            shrinkWrap: true,
                            children: List.generate(
                              _controller.searchReels.length,
                              (index) => SearchTagTile(index: index),
                            ).toList(),
                          ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
