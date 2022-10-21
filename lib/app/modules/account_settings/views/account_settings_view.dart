import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/assets.dart';
import '../../create_giveaway/views/create_giveaway_view.dart';
import '../../follower_picker/views/follower_picker_view.dart';
import '../../my_contest/views/my_contest_view.dart';
import '../controllers/account_settings_controller.dart';

class AccountSettingsView extends GetView<AccountSettingsController> {
  AccountSettingsView({Key? key}) : super(key: key);
  final _controller = Get.put(AccountSettingsController());
  final _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    _controller.getContestByUser();
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: const Text(
          "Account Settings",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Get.height * 0.015,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "ACCOUNT",
              style: style.titleMedium,
            ),
          ),
          AccountTile(
            asset: Assets.accountStoke,
            title: "Manage my account",
            onPressed: () {},
          ),
          AccountTile(
            asset: Assets.lock,
            title: "Privacy and safety",
            onPressed: () {},
          ),
          AccountTile(
            asset: Assets.share,
            title: "Share profile",
            onPressed: () {},
          ),
          AccountTile(
            asset: Assets.qrcode,
            title: "QR Code",
            onPressed: () {},
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("GENERAL", style: style.titleMedium),
          ),
          AccountTile(
            asset: Assets.bell,
            title: "Push notifications",
            onPressed: () {},
          ),
          GetBuilder<AccountSettingsController>(
              builder: (_) => AccountTile(
                    asset: Assets.gift,
                    title: "Giveaway",
                    onPressed: () async {
                      await _controller.getContestByUser();
                      if (_controller.contestModel == null) {
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text(
                              "Enable Giveaway Campaigns",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(22, 22, 22, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            content: const Text(
                              "You haven’t enabled giveaway campaign."
                              "\nDo you want to enable now and"
                              "\nstart a new campaign right away?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(68, 67, 65, 1),
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 42,
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            253, 196, 64, 1),
                                        elevation: 9,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                        Get.to(CreateGiveawayView());
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromRGBO(68, 67, 65, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.04,
                                  ),
                                  SizedBox(
                                    height: 42,
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            217, 217, 217, 1),
                                        elevation: 8,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromRGBO(68, 67, 65, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        final val = await Get.to(
                            () => MyContestView(_controller.contestModel!));
                        if (val != null) {
                          _controller.getContestByUser();
                        }
                      }
                    },
                  )),
          AccountTile(
            asset: Assets.accountStoke,
            title: "Random Follower Picker",
            onPressed: () async {
              await _controller.getContestByUser();
              if (_controller.contestModel == null) {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      "Enable Giveaway Campaigns",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(22, 22, 22, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    content: const Text(
                      "You haven’t enabled giveaway campaign."
                      "\nDo you want to enable now and"
                      "\nstart a new campaign right away?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(68, 67, 65, 1),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 42,
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(253, 196, 64, 1),
                                elevation: 9,
                              ),
                              onPressed: () {
                                Get.back();
                                Get.to(CreateGiveawayView());
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(68, 67, 65, 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.04,
                          ),
                          SizedBox(
                            height: 42,
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(217, 217, 217, 1),
                                elevation: 8,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(68, 67, 65, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (_controller.contestModel!.winnerName != '') {
                Get.to(() => FollowerPickerWinnerView(
                    _controller.contestModel!.winnerName));
              } else {
                Get.to(() => FollowerPickerView(_controller.contestModel!));
              }
            },
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "SUPPORT",
              style: style.titleMedium,
            ),
          ),
          AccountTile(
            asset: Assets.pen,
            title: "Report a problem",
            onPressed: () {},
          ),
          AccountTile(
            asset: Assets.help,
            title: "Help",
            onPressed: () {},
          ),
          AccountTile(
            asset: Assets.bell,
            title: "Logout",
            onPressed: () {
              _authService.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String asset;
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
              icon: Image.asset(
                asset,
                height: 16,
                width: 14,
              ),
            ),
            Text(
              title,
              style: style.titleMedium,
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
