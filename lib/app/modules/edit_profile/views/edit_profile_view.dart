import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Image.asset(
            "assets/Left Arrow Icon.png",
            height: 18,
            width: 10.21,
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color.fromRGBO(22, 23, 34, 1),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.03,
          ),
          const Center(
            child: CircleAvatar(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
              backgroundImage: AssetImage("assets/Profile Photo.png"),
              radius: 45,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          const Text(
            "Change photo",
            style: TextStyle(
              color: Color.fromRGBO(22, 23, 34, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
          ),
          ),
          SizedBox(
            height: Get.height * 0.06,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Name",
                  style: TextStyle(
                    color: Color.fromRGBO(22, 23, 34, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 222),
                child: Text(
                  "Jacob West",
                  style: TextStyle(
                    color: Color.fromRGBO(134, 135, 139, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Username",
                  style: TextStyle(
                    color: Color.fromRGBO(22, 23, 34, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 218),
                child: Text(
                  "jacob_w",
                  style: TextStyle(
                    color: Color.fromRGBO(134, 135, 139, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
              const Padding(
                padding: EdgeInsets.only(left: 210),
                child: Text(
                  "tiktok.com@jacob_w",
                  style: TextStyle(
                    color: Color.fromRGBO(134, 135, 139, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Bio",
                  style: TextStyle(
                    color: Color.fromRGBO(22, 23, 34, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 163),
                child: Text(
                  "Add a bio to your profile",
                  style: TextStyle(
                    color: Color.fromRGBO(134, 135, 139, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Color.fromRGBO(22, 23, 34, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 258),
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Color.fromRGBO(134, 135, 139, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Phone",
                  style: TextStyle(
                    color: Color.fromRGBO(22, 23, 34, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 235),
                child: Text(
                  "Number",
                  style: TextStyle(
                    color: Color.fromRGBO(134, 135, 139, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
