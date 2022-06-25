import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';

import '../../../utils/assets.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              Assets.homePageBackground,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            // (Get.height / 2) - 50,
            child: Column(
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.card_giftcard,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () {}),
                const Text('1240',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () {}),
                const Text('328.7K',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                IconButton(
                    icon: const Icon(
                      Icons.comment,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () {}),
                const Text('578',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                IconButton(
                    icon: const Icon(
                      Icons.share,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () {}),
                const Text('Share',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                IconButton(
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () {}),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/cucumia-369c1.appspot.com/o/images%2FMagazines%2F2022-06-17%2015%3A03%3A33.892_2022-06-17%2015%3A03%3A33.893.jpg?alt=media&token=75624798-52a6-4735-a422-092955a6aa3a"),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@waterman',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width * 0.8,
                  child: const Text(
                    'Partying hard under water. Feeling chill. #waterboy #partyhard #mylife #underwaterlife',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      color: Colors.white,
                    ),
                    Container(
                      width: Get.width * 0.8,
                      child: const Text(
                        'Just Good Music 24/7 Stay See Live Radio 🎧',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
