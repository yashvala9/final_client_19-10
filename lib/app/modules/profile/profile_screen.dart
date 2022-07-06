// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/widgets/loading.dart';
import '../../../utils/assets.dart';
import '../edit_profile/views/edit_profile_view.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final _controller = Get.put(ProfileController());
  final authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<ProfileController>(
      builder: (_) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
          actions: [
            IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
          ],
        ),
        body: _controller.loading
            ? Loading()
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(0, 0, 0, 0.6),
                                    backgroundImage: AssetImage(Assets.profile),
                                    radius: 45,
                                  ),
                                ),
                                
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _controller.profileModel.username,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                _controller.profileModel.isVerified
                                    ? Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.25,
                                  child: Column(
                                    children: [
                                      Text(
                                        '9',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Posts',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.25,
                                  child: Column(
                                    children: [
                                      Text(
                                        '14',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Following',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.25,
                                  child: Column(
                                    children: [
                                      Text(
                                        '38',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Followers',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() =>
                                    EditProfileView(_controller.profileModel));
                              },
                              child: Container(
                                width: Get.width * 0.9,
                                height: 47,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: Text(
                                    'Edit Profile',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            // video list
                            Container(
                              width: Get.width * 0.9,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 240, 218, 1),
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      "Upcoming giveaway on 18th June.",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    )),
                                    Center(
                                        child: Text(
                                      "Stay Tuned",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    )),
                                    Center(
                                      child: Text(
                                        "Engineer who love dancing, modelling, photography. DM me for collaboration",
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _tabSection(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(tabs: [
            Tab(text: "Rolls"),
            Tab(text: "Photos"),
            Tab(text: "Giveaway"),
          ]),
          SizedBox(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  String thumbnail =
                      "https://images.unsplash.com/photo-1656311877606-778f297e00d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80";
                  return CachedNetworkImage(
                    imageUrl: thumbnail,
                    fit: BoxFit.cover,
                  );
                },
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  String thumbnail =
                      "https://images.unsplash.com/photo-1656311877606-778f297e00d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80";
                  return CachedNetworkImage(
                    imageUrl: thumbnail,
                    fit: BoxFit.cover,
                  );
                },
              ),
              Container(
                child: Center(child: Text("Giveaway")),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
