import 'dart:async';
import 'dart:developer';

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
import 'package:reel_ro/widgets/shimmer_animation.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';
import '../../../repositories/reel_repository.dart';
import '../../../services/auth_service.dart';
import '../../../utils/assets.dart';
import '../../../utils/base.dart';
import '../../../widgets/loading.dart';
import '../profile/profile_controller.dart';
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

  final _profileRepo = Get.find<ProfileRepository>();
  final _controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black87,
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
                      child: TextFormField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade600,
                            enabled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.white),
                            hintText: "Search here...",
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TabBar(labelColor: Colors.white, tabs: const [
                Tab(
                  text: "Rolls",
                ),
                Tab(
                  text: "Photos",
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _controller.loading
                          ? const Expanded(
                              child: Loading(),
                            )
                          : _controller.reelList.isEmpty
                              ? const Expanded(
                                  child: Center(
                                    child: Text("No reels available"),
                                  ),
                                )
                              : Expanded(
                                  child:
                                      NotificationListener<ScrollNotification>(
                                    onNotification: (notification) {
                                      if (!_controller.loadingMore &&
                                          notification.metrics.pixels ==
                                              notification
                                                  .metrics.maxScrollExtent) {
                                        log("Loading...");
                                        _controller.getMoreFeed(
                                            _controller.reelList.length);
                                      }
                                      return true;
                                    },
                                    child: CustomScrollView(
                                      shrinkWrap: true,
                                      slivers: [
                                        SliverGrid(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 2,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              var isPhoto = _controller
                                                      .reelList[index]
                                                      .media_ext !=
                                                  'mp4';
                                              return GestureDetector(
                                                  onTap: () {
                                                    Get.to(SingleFeedScreen(
                                                      null,
                                                      _controller.reelList,
                                                      index,
                                                    ));
                                                  },
                                                  child: isPhoto
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              "${Base.profileBucketUrl}/${_controller.reelList[index].filename}",
                                                          fit: BoxFit.cover,
                                                          errorWidget: (c, s,
                                                                  e) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        )
                                                      : FutureBuilder<String>(
                                                          future: _profileRepo
                                                              .getThumbnail(
                                                                  _controller
                                                                      .reelList[
                                                                          index]
                                                                      .thumbnail),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const ShimmerCardAnimation();
                                                            }

                                                            return CachedNetworkImage(
                                                              key: UniqueKey(),
                                                              placeholder:
                                                                  (context,
                                                                      url) {
                                                                return const ShimmerCardAnimation();
                                                              },
                                                              errorWidget:
                                                                  (_, a, b) {
                                                                return const ShimmerCardAnimation();
                                                              },
                                                              imageUrl: snapshot
                                                                  .data!,
                                                              fit: BoxFit.cover,
                                                            );
                                                          },
                                                        ));
                                            },
                                            childCount:
                                                _controller.reelList.length,
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Center(
                                            child: _controller.loadingMore
                                                ? const Loading()
                                                : const SizedBox(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Photos",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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

  final _controller = Get.isRegistered<SearchController>()
      ? Get.find<SearchController>()
      : Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

                    // controller: searchTextController,
                    onChanged: (value) {
                      _debounce.run(() {
                        if (value.startsWith('#')) {
                          value.replaceAll('#', '');
                          // Get.to(SearchHashTags(
                          //   hashTag: value.trim(),
                          // ));

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

  final _controller = Get.isRegistered<SearchController>()
      ? Get.find<SearchController>()
      : Get.put(SearchController());

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
