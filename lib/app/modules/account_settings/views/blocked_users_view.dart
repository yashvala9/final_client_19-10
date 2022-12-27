import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/repositories/profile_repository.dart';

import '../../../../utils/base.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/empty_widget.dart';
import '../../../../utils/snackbar.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/my_elevated_button.dart';
import '../../homepage/profile_detail_screen.dart';
import '../../search/widget/search_tag_tile.dart';
import '../../single_feed/single_feed_screen.dart';
import '../controllers/account_settings_controller.dart';

class BlockedUserView extends StatelessWidget {
  BlockedUserView({Key? key}) : super(key: key);

  final controller = Get.put(AccountSettingsController());
  final _formKey = GlobalKey<FormState>();

  final parser = EmojiParser();
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Blocked Users",
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              Expanded(
                child: Obx(
                  () => controller.isbUserLoading.value
                      ? Loading()
                      : controller.blockedUsers.isEmpty
                          ? const EmptyWidget("No details found")
                          : ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                controller.blockedUsers.length,
                                (index) => ListTile(
                                  onTap: () => Get.to(
                                    () => ProfileDetail(
                                        profileModel:
                                            controller.blockedUsers[index],
                                        onBack: () {
                                          Get.back();
                                        }),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      "${Base.profileBucketUrl}/${controller.blockedUsers[index].user_profile!.profile_img}",
                                    ),
                                  ),
                                  title: Text(
                                    controller.blockedUsers[index].user_profile!
                                        .fullname!,
                                    style: style.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  trailing: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: OutlinedButton(
                                      style: ButtonStyle(
                                        side: MaterialStateProperty.resolveWith(
                                            (states) {
                                          Color _borderColor;

                                          _borderColor = Colors.white;

                                          return BorderSide(
                                              color: _borderColor, width: 1);
                                        }),
                                      ),
                                      onPressed: () {
                                        Get.dialog(AlertDialog(
                                          backgroundColor: Colors.black54,
                                          title: const Text(
                                            "Do you wish to unblock?",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                                ProfileRepository().unblockUser(
                                                    controller
                                                        .blockedUsers[index].id,
                                                    controller.token!);
                                                controller.onInit();
                                              },
                                              child: const Text("Confirm"),
                                              color: AppColors.buttonColor,
                                            ),
                                          ],
                                        ));
                                      },
                                      child: Text(
                                        "Unblock",
                                        style: style.caption!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
