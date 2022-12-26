import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/account_settings/views/blocked_users_view.dart';
import 'package:reel_ro/app/modules/account_settings/views/change_password_view.dart';
import 'package:reel_ro/app/modules/account_settings/views/help_view.dart';
import 'package:reel_ro/app/modules/account_settings/views/liked_video_view.dart';
import 'package:reel_ro/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:reel_ro/app/modules/referrals/views/referrals_view.dart';
import 'package:reel_ro/app/modules/send_invite/views/send_invite_view.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../repositories/profile_repository.dart';
import '../../../../utils/colors.dart';
import '../../create_giveaway/views/create_giveaway_view.dart';
import '../../follower_picker/views/follower_picker_view.dart';
import '../../my_contest/views/my_contest_view.dart';
import '../controllers/account_settings_controller.dart';

class ManageAccountView extends GetView<AccountSettingsController> {
  ManageAccountView({Key? key}) : super(key: key);
  final _controller = Get.put(AccountSettingsController());
  final _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    _controller.getContestByUser();
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text(
          "Manage My account",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * 0.015,
            ),
            AccountTile(
              asset: Icons.person,
              title: "Edit Profile",
              onPressed: () {
                Get.to(EditProfileView(
                  profileEditCalBack: () {},
                ));
              },
            ),
            AccountTile(
              asset: Icons.password,
              title: "Change Password",
              onPressed: () {
                Get.to(ChangePasswordView());
              },
            ),
            AccountTile(
              asset: Icons.person_off,
              title: "Blocked Users",
              onPressed: () {
                Get.to(BlockedUserView());
              },
            ),
            AccountTile(
              asset: Icons.favorite,
              title: "Liked Videos",
              onPressed: () {
                // Get.to(LikedVideoView());
              },
            ),
            AccountTile(
              asset: Icons.code,
              title: "Referral Code",
              onPressed: () {
                Get.to(SendInviteView());
              },
            ),
            AccountTile(
              asset: Icons.group,
              title: "Referrals List",
              onPressed: () {
                Get.to(ReferralsView());
              },
            ),
            AccountTile(
              asset: Icons.cancel_presentation_rounded,
              title: "Deactivate Account",
              onPressed: () {
                Get.dialog(AlertDialog(
                  title: const Text(
                      "Are you sure you want to deactivate this account?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          ProfileRepository()
                              .deactivateAccount(_authService.token!);
                          Get.back();
                        },
                        child: const Text("NO")),
                    MaterialButton(
                      onPressed: () {},
                      child: const Text("YES"),
                      color: Colors.red,
                    ),
                  ],
                ));
              },
            ),
            AccountTile(
              asset: Icons.delete_forever,
              title: "Delete Account",
              onPressed: () {
                Get.dialog(AlertDialog(
                  title: const Text(
                      "Are you sure you want to delete this account?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          ProfileRepository()
                              .deactivateAccount(_authService.token!);
                          Get.back();
                        },
                        child: const Text("NO")),
                    MaterialButton(
                      onPressed: () {},
                      child: const Text("YES"),
                      color: Colors.red,
                    ),
                  ],
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final IconData asset;
  final String title;
  final VoidCallback onPressed;
  const AccountTile(
      {Key? key,
      required this.asset,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                asset,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: style.titleMedium!.copyWith(color: Colors.white),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xff86878B),
            )
          ],
        ),
      ),
    );
  }
}
