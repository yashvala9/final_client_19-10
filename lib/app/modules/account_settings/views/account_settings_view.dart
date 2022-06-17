import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../edit_profile/views/edit_profile_view.dart';
import '../../follower_picker/views/follower_picker_view.dart';
import '../../giveaway_campaign/views/giveaway_campaign_view.dart';
import '../controllers/account_settings_controller.dart';

class AccountSettingsView extends GetView<AccountSettingsController> {
  const AccountSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/Left Arrow Icon.png",
            height: 18,
            width: 10.21,
          ),
        ),
        title: const Text(
          "Account Settings",
          style: TextStyle(
            color: Color.fromRGBO(22, 23, 34, 1),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Get.height * 0.015,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "ACCOUNT",
              style: TextStyle(
                color: Color.fromRGBO(134, 135, 139, 1),
                fontSize: 14,
                fontWeight: FontWeight.w700,
            ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Account Stroke Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Manage my account",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
              ),
              ),
              SizedBox(
                width: Get.width * 0.4,
              ),
              IconButton(
                onPressed: () {
                  Get.to(const EditProfileView());
                },
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Lock Stroke Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Privacy and safety",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.435,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Share Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Share profile",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.53,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/QR Code Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "QR Code",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.59,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          const Divider(
            color: Color.fromRGBO(208, 209, 211, 1),
            thickness: 0.66,
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "GENERAL",
              style: TextStyle(
                color: Color.fromRGBO(134, 135, 139, 1),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Bell Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Push notifications",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.43,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Book Stroke Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Language",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.57,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Gift Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Giveaway",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.57,
              ),
              IconButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
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
                          children: [
                            SizedBox(
                              height: 42,
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(253, 196, 64, 1),
                                  elevation: 9,
                              ),
                                onPressed: () {
                                  Get.to(const GiveawayCampaignView());
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
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(217, 217, 217, 1),
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
                },
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Account Stroke Icon 2.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Random Follower Picker",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.32,
              ),
              IconButton(
                onPressed: () {
                  Get.to(const FollowerPickerView());
                },
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          const Divider(
            color: Color.fromRGBO(208, 209, 211, 1),
            thickness: 0.66,
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "SUPPORT",
              style: TextStyle(
                color: Color.fromRGBO(134, 135, 139, 1),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Pen Stroke Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Report a problem",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.43,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Question Stroke Icon.png",
                  height: 16,
                  width: 14,
                ),
              ),
              const Text(
                "Help Center",
                style: TextStyle(
                  color: Color.fromRGBO(22, 23, 34, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: Get.width * 0.52,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Right Arrow Icon.png",
                  height: 10.5,
                  width: 5.79,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}