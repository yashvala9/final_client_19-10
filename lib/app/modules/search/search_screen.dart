import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/app/modules/search/widget/search_tile.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/utils/video_player_item.dart';
import 'package:reel_ro/widgets/shimmer_animation.dart';

import '../../../repositories/profile_repository.dart';
import '../../../utils/base.dart';
import '../../../widgets/loading.dart';
import '../single_feed/single_feed_screen.dart';
import 'widget/search_tag_tile.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  // ignore: unused_field
  final _controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        body: GetBuilder<SearchController>(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Hero(
                tag: 'search',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          () => SearchUsers(username: ""),
                        );
                      },
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 54, 54, 54),
                              enabled: false,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              hintText: "Search here...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const TabBar(labelColor: Colors.white, tabs: [
                Tab(
                  text: "Rolls",
                ),
                Tab(
                  text: "Photos",
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: ReelsTab(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: PhotosTab(),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchUsers extends StatelessWidget {
  final String username;
  SearchUsers({Key? key, required this.username}) : super(key: key);
  final _debounce = Debouncer(milliseconds: 500);

  final _controller = Get.isRegistered<SearchController>() ? Get.find<SearchController>() : Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return WillPopScope(
      onWillPop: () async {
        _controller.searchProfiles.clear();
        return true;
      },
      child: SafeArea(
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
              Hero(
                tag: 'search',
                child: Material(
                  color: Colors.transparent,
                  child: TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search here...",
                    ),
                    onChanged: (value) {
                      _debounce.run(() {
                        if (value.startsWith('#')) {
                          value.replaceAll('#', '');

                          _controller.getReelsByHashTag(value);
                        } else {
                          _controller.searchUser(value);
                        }
                      });
                    },
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
              GetBuilder<SearchController>(
                builder: (_) => Expanded(
                  child: _controller.loading
                      ? Loading()
                      : _controller.searchProfiles.isEmpty
                          ? const EmptyWidget("No details found")
                          : ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                _controller.searchProfiles.length,
                                (index) => SearchTile(index: index),
                              ).toList(),
                            ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class SearchHashTags extends StatelessWidget {
  final String hashTag;
  SearchHashTags({Key? key, required this.hashTag}) : super(key: key);

  final _controller = Get.isRegistered<SearchController>() ? Get.find<SearchController>() : Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
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
                    ? Loading()
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

class ReelsTab extends StatelessWidget {
  ReelsTab({Key? key}) : super(key: key);

  final _controller = Get.find<SearchController>();
  final _profileRepo = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _controller.loading
            ? Expanded(
                child: Loading(),
              )
            : _controller.reelList.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text("No reels available"),
                    ),
                  )
                : Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (!_controller.loadingMore &&
                            notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                          log("Loading...");
                          _controller.getMoreFeed(_controller.reelList.length);
                        }
                        return true;
                      },
                      child: GridView.custom(
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 3,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: const [
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(3, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var isPhoto = _controller.reelList[index].media_ext != 'mp4';
                            var reel = _controller.reelList[index];
                            var videoSplit = [''];
                            var videoUrl = '';
                            if (!isPhoto) {
                              videoSplit = _controller.reelList[index].filename.split("_");
                              videoUrl = _controller.reelList[index].filepath;
                              // "https://d2qwvdd0y3hlmq.cloudfront.net/${videoSplit[0]}/${videoSplit[1]}/${videoSplit[2]}/${reel.filename}/MP4/${reel.filename}";
                            }
                            return GestureDetector(
                                onTap: () {
                                  Get.to(SingleFeedScreen(
                                    null,
                                    _controller.reelList,
                                    index,
                                    null,
                                    isPhoto: false,
                                  ));
                                },
                                child: (index % 14 == 1 || index % 14 == 10)
                                    ? VideoPlayerItem(
                                        videoUrl: videoUrl,
                                        videoId: _controller.reelList[index].id,
                                        onTap: () {
                                          Get.to(SingleFeedScreen(
                                            null,
                                            _controller.reelList,
                                            index,
                                            null,
                                            isPhoto: false,
                                          ));
                                        },
                                        doubleTap: () {},
                                        swipeRight: () {},
                                        enableAudio: false,
                                        updatePoints: () {},
                                        isReel: true)
                                    : FutureBuilder<String>(
                                        future: _profileRepo.getThumbnail(_controller.reelList[index].thumbnail),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return ShimmerCardAnimation(isBlack: true);
                                          }

                                          return CachedNetworkImage(
                                            key: UniqueKey(),
                                            placeholder: (context, url) {
                                              return ShimmerCardAnimation(isBlack: true);
                                            },
                                            errorWidget: (_, a, b) {
                                              return ShimmerCardAnimation(isBlack: true);
                                            },
                                            imageUrl: snapshot.data!,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ));
                          },
                          childCount: _controller.reelList.length,
                        ),
                      ),
                    ),
                  ),
      ],
    );
  }
}

class PhotosTab extends StatelessWidget {
  PhotosTab({Key? key}) : super(key: key);

  final _controller = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _controller.loading
            ? Expanded(
                child: Loading(),
              )
            : _controller.photosList.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text("No reels available"),
                    ),
                  )
                : Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (!_controller.loadingMore &&
                            notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                          log("Loading...");
                          _controller.getMorePhotos(_controller.photosList.length);
                        }
                        return true;
                      },
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Get.to(SingleFeedScreen(
                                        [_controller.photosList[index]],
                                        null,
                                        index,
                                        null,
                                        isPhoto: true,
                                      ));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: "${Base.profileBucketUrl}/${_controller.photosList[index].filename}",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return ShimmerCardAnimation();
                                      },
                                      errorWidget: (c, s, e) => const Icon(Icons.error),
                                    ));
                              },
                              childCount: _controller.photosList.length,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: _controller.loadingMore ? Loading() : const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ],
    );
  }
}
