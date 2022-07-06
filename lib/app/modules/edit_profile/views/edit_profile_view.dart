import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/utils/assets.dart';
import '../../../../utils/snackbar.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView(this.profileModel, {Key? key}) : super(key: key);
  final ProfileModel profileModel;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              showSnackBar('button pressed');
              Get.back();
            }),
        title: const Center(child: Text("Edit Profille")),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.add_box_outlined), onPressed: () {}),
        ],
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.03,
          ),
          const Center(
            child: CircleAvatar(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
              backgroundImage: AssetImage(Assets.profile),
              radius: 45,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Text(
            "Change photo",
            style: style.titleMedium,
          ),
          SizedBox(
            height: Get.height * 0.06,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Name",
                  style: style.titleMedium,
                ),
              ),
              const Spacer(),
              Text(
                "Jacob West",
                style: style.titleMedium,
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Username",
                  style: style.titleMedium,
                ),
              ),
              const Spacer(),
              Text(
                "jacob_w",
                style: style.titleMedium,
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
              const Spacer(),
              Text(
                "tiktok.com@jacob_w",
                style: style.titleMedium,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/Clipboard Stroke Icon.png",
                  height: 13,
                  width: 12.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Bio",
                  style: style.titleMedium,
                ),
              ),
              const Spacer(),
              Text(
                "Add a bio to your profile",
                style: style.titleMedium,
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
            thickness: 0.33,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Email",
                  style: style.titleMedium,
                ),
              ),
              const Spacer(),
              Text(
                "Email",
                style: style.titleMedium,
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Phone",
                  style: style.titleMedium,
                ),
              ),
              const Spacer(),
              Text(
                "Number",
                style: style.titleMedium,
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
