import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/repositories/profile_repository.dart';

import '../../../../utils/base.dart';
import '../../../../utils/colors.dart';
import '../../homepage/profile_detail_screen.dart';

class SearchTile extends StatelessWidget {
  final int index;
  SearchTile({Key? key, required this.index}) : super(key: key);

  final _controller = Get.find<SearchController>();
  final _profileRepo = Get.put(ProfileRepository());
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;
    return GetBuilder<SearchController>(builder: (_) {
      var profileModel = _controller.searchProfiles[index];
      return ListTile(
        onTap: () => Get.to(
          () => ProfileDetail(
              profileModel: profileModel,
              onBack: () {
                Get.back();
              }),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: colorSchem.primary,
          backgroundImage: NetworkImage(
            profileModel.user_profile != null
                ? "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}"
                : "",
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
          child: FutureBuilder<bool>(
              future:
                  _profileRepo.isFollowing(profileModel.id, _controller.token!),
              builder: (context, snap) {
                return OutlinedButton(
                  onPressed: () {
                    Get.dialog(AlertDialog(
                      backgroundColor: Colors.black54,
                      title: snap.data!
                          ? const Text(
                              "Do you wish to unfollow?",
                              style: TextStyle(color: Colors.white),
                            )
                          : const Text(
                              "Do you wish to follow?",
                              style: TextStyle(color: Colors.white),
                            ),
                      actionsAlignment: MainAxisAlignment.spaceAround,
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("Cancel")),
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                            _controller.toggleFollowing(index);
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
              }),
        ),
      );
    });
  }
}
