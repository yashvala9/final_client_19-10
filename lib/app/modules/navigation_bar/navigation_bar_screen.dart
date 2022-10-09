import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/giveaway/views/giveaway_view.dart';
import 'package:reel_ro/app/modules/profile/profile_screen.dart';
import 'package:reel_ro/app/modules/search/search_screen.dart';

import '../chat/chat_list.dart';
import '../homepage/homepage_screen.dart';
import 'navigation_bar_controller.dart';

class NavigationBarScreen extends StatelessWidget {
  NavigationBarScreen({Key? key}) : super(key: key);

  final NavigationBarController controller = Get.put(NavigationBarController());
  final homepage = HomePageScreen();

  buildBottomNavigationMenu(context) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          height: 66,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      if (controller.tabIndex.value != 0) {
                        controller.changeTabIndex(0);
                        homepage.moveToReel();
                      } else {
                        if (homepage.controller.secondPageIndex != 0) {
                          homepage.moveToReel();
                        } else if (homepage.pageController.page != 0) {
                          homepage.goToFirstPage();
                        } else {
                          homepage.controller.getFeeds();
                          homepage.controller.update();
                        }
                      }
                    },
                    icon: controller.tabIndex.value == 0
                        ? const Icon(
                            Icons.home,
                            color: Colors.pink,
                            size: 30,
                          )
                        : const Icon(
                            Icons.home_outlined,
                            color: Colors.grey,
                            size: 28,
                          ),
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      controller.changeTabIndex(1);
                    },
                    icon: controller.tabIndex.value == 1
                        ? const Icon(
                            Icons.search,
                            color: Colors.pink,
                            size: 30,
                          )
                        : const Icon(
                            Icons.search_outlined,
                            color: Colors.grey,
                            size: 28,
                          ),
                  ),
                  const Text(
                    'Search',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      controller.changeTabIndex(2);
                    },
                    icon: controller.tabIndex.value == 2
                        ? const Icon(
                            Icons.card_giftcard,
                            color: Colors.pink,
                            size: 30,
                          )
                        : const Icon(
                            Icons.card_giftcard_outlined,
                            color: Colors.grey,
                            size: 28,
                          ),
                  ),
                  const Text(
                    'Giveaway',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      controller.changeTabIndex(3);
                    },
                    icon: controller.tabIndex.value == 3
                        ? const Icon(
                            Icons.message,
                            color: Colors.pink,
                            size: 30,
                          )
                        : const Icon(
                            Icons.message_outlined,
                            color: Colors.grey,
                            size: 28,
                          ),
                  ),
                  const Text(
                    'Inbox',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      controller.changeTabIndex(4);
                    },
                    icon: controller.tabIndex.value == 4
                        ? const Icon(
                            Icons.person,
                            color: Colors.pink,
                            size: 30,
                          )
                        : const Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                            size: 28,
                          ),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.retrieveDynamicLink(context);
    });
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: buildBottomNavigationMenu(context),
            body: Obx(
              () => IndexedStack(
                children: <Widget>[
                  homepage,
                  SearchScreen(),
                  GiveawayView(),
                  ChatList(),
                  const ProfileScreen(),
                ],
                index: controller.tabIndex.value,
              ),
            )));
  }
}
