import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/profile_detail_screen.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/app/modules/single_feed/single_feed_screen.dart';
import 'package:reel_ro/repositories/profile_repository.dart';

import '../../../../utils/base.dart';

class SearchTagTile extends StatelessWidget {
  final int index;
  SearchTagTile({Key? key, required this.index}) : super(key: key);

  final _controller = Get.find<SearchController>();
  final _profileRepo = Get.put(ProfileRepository());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;
    var parser = EmojiParser();
    return GetBuilder<SearchController>(builder: (_) {
      var reelModel = _controller.searchReels[index];
      return ListTile(
        onTap: () => Get.to(
          () => SingleFeedScreen(_controller.searchReels, index),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: FutureBuilder<String>(
          future: _profileRepo
              .getThumbnail(_controller.searchReels[index].thumbnail),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return CircleAvatar(
              radius: 25,
              backgroundColor: colorSchem.primary,
              backgroundImage: NetworkImage(
                snapshot.data!,
              ),
            );
          },
        ),
        title: Text(
          parser.emojify(reelModel.video_title),
          style: style.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          parser.emojify(reelModel.description),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    });
  }
}
