import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/profile_detail_screen.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';

class SearchTile extends StatelessWidget {
  final int index;
  SearchTile({Key? key, required this.index}) : super(key: key);

  final _controller = Get.find<SearchController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;
    return GetBuilder<SearchController>(builder: (_) {
      var profileModel = _controller.searchProfiles[index];
      return ListTile(
        onTap: () => Get.to(
          () => ProfileDetail(
            index: index,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: colorSchem.primary,
          backgroundImage: const NetworkImage(
            "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
          ),
        ),
        title: Text(
          profileModel.user_profile!.fullname!,
          style: style.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          profileModel.username!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: OutlinedButton(
            onPressed: () {
              _controller.toggleFollowing(index);
            },
            child: Text(
              profileModel.isFollowing! ? "Following" : "Follow",
              style: style.caption,
            ),
          ),
        ),
      );
    });
  }
}
