// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/homepage/comment_panel.dart';
import 'package:reel_ro/app/modules/homepage/homepage_controller.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/assets.dart';
import '../../../utils/circle_animation.dart';
import '../../../utils/colors.dart';
import '../../../utils/video_player_iten.dart';
import 'action_bar.dart';
import 'comment_screen.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  final _controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
        title: const Center(child: Text("Rolls For You")),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.add_box_outlined), onPressed: () {}),
        ],
      ),
      body: Obx(() {
        return PageView.builder(
          itemCount: _controller.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = _controller.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    data.username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    data.caption,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        data.songName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: size.height / 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      // _controller.likeVideo(data.id),
                                      child: const Icon(
                                        Icons.card_giftcard,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.likes.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      // _controller.likeVideo(data.id),
                                      child: const Icon(
                                        Icons.favorite,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.likes.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: const Text(
                                                        '2 Comments',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    trailing: IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ),
                                                  Divider(),
                                                  ListTile(
                                                    leading: buildProfile(""),
                                                    title: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '@yashvala9',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                '1 day ago',
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Hey! check this out.',
                                                              ),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                      )),
                                                                  Text('2'),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          InkWell(
                                                              onTap: () {},
                                                              child: Text(
                                                                '2 Responses',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    leading: buildProfile(""),
                                                    title: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '@yashvala9',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                '1 day ago',
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Hey! check this out.',
                                                              ),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                      )),
                                                                  Text('2'),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          InkWell(
                                                              onTap: () {},
                                                              child: Text(
                                                                '2 Responses',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width * 0.80,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                ' Add a comment',
                                                            prefixIcon:
                                                                buildProfile(
                                                                    ""),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Icon(
                                        Icons.comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.commentCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.reply,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.shareCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                CircleAnimation(
                                  child: buildMusicAlbum(data.profilePhoto),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: const Image(
                image: AssetImage(
                  "assets/Background.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }
}
