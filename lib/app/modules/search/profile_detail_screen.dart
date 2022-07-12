import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/profile_detail_controller.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/models/profile_model.dart';

import '../../../utils/assets.dart';
import '../../../widgets/my_elevated_button.dart';
import '../profile/profile_screen.dart';

class ProfileDetail extends StatelessWidget {
  final int index;
  ProfileDetail({Key? key, required this.index}) : super(key: key);
  final _controller = Get.find<SearchController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return DefaultTabController(
      length: _controller.searchProfiles[index].isVerified ? 3 : 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  GetBuilder<SearchController>(builder: (_) {
                    var profileModel = _controller.searchProfiles[index];
                    return Stack(
                      children: [
                        Container(
                          height: Get.height * 0.2,
                          color: colorScheme.primaryContainer,
                        ),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 100, bottom: 10),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40))),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                                child: Material(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.08,
                                      ),
                                      Text(
                                        profileModel.fullname,
                                        style: style.headline5,
                                      ),
                                      SizedBox(
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: ListTile(
                                              title: Text(
                                                  profileModel.noOfPosts
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: style.headline6),
                                              subtitle: Text(
                                                "Posts",
                                                textAlign: TextAlign.center,
                                                style: style.titleMedium,
                                              ),
                                            )),
                                            Expanded(
                                                child: ListTile(
                                              title: Text(
                                                  profileModel.followerCount
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: style.headline6),
                                              subtitle: Text("Followers",
                                                  textAlign: TextAlign.center,
                                                  style: style.titleMedium),
                                            )),
                                            Expanded(
                                                child: ListTile(
                                              title: Text(
                                                  profileModel.followingCount
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: style.headline6),
                                              subtitle: Text("Followings",
                                                  textAlign: TextAlign.center,
                                                  style: style.titleMedium),
                                            )),
                                          ],
                                        ),
                                      ),
                                      // Padding(
                                      //   padding:
                                      //       const EdgeInsets.symmetric(
                                      //         horizontal: 20,
                                      //         vertical: 8,
                                      //       ),
                                      //   child: OutlinedButton(
                                      //     onPressed: () {},
                                      //     style: OutlinedButton.styleFrom(
                                      //       minimumSize:
                                      //           Size.fromHeight(40),
                                      //     ),
                                      //     child: Text("Edit Profile",style: style.titleMedium,),
                                      //   ),
                                      // ),
                                      profileModel.isFollowing!
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 8,
                                              ),
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  _controller
                                                      .toggleFollowing(index);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  minimumSize:
                                                      const Size.fromHeight(40),
                                                ),
                                                child: Text(
                                                  "Following",
                                                  style: style.titleMedium,
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: MyElevatedButton(
                                                        buttonText: "Follow",
                                                        onPressed: () {
                                                          _controller
                                                              .toggleFollowing(
                                                                  index);
                                                        },
                                                        height: 30,
                                                        style:
                                                            style.titleMedium,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: OutlinedButton(
                                                      onPressed: () {},
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                              minimumSize:
                                                                  const Size
                                                                          .fromHeight(
                                                                      50)),
                                                      child: Text(
                                                        "Message",
                                                        style:
                                                            style.titleMedium,
                                                      ),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                      Container(
                                        width: Get.width * 0.9,
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                255, 240, 218, 1),
                                            border: Border.all(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: const [
                                              Center(
                                                  child: Text(
                                                "Upcoming giveaway on 18th June.",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              )),
                                              Center(
                                                  child: Text(
                                                "Stay Tuned",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              )),
                                              Center(
                                                child: Text(
                                                  "Engineer who love dancing, modelling, photography. DM me for collaboration",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: Get.height * 0.08,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Material(
                                    elevation: 3,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          AssetImage(Assets.profile),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  })
                ]),
              )
            ];
          },
          body: _tabSection(context, _controller.searchProfiles[index]),
        ),
      ),
    );
  }

  Widget _tabSection(BuildContext context, ProfileModel profileModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(tabs: [
          const Tab(text: "Rolls"),
          const Tab(text: "Photos"),
          if (profileModel.isVerified) const Tab(text: "Giveaway"),
        ]),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: TabBarView(children: [
            ProfileReel(
              profileId: profileModel.id,
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
            if (profileModel.isVerified) const Center(child: Text("Giveaway")),
          ]),
        ),
      ],
    );
  }
}
