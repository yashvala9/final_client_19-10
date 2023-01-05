import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/giveaway/views/giveaway_view.dart';
import 'package:reel_ro/app/modules/profile/profile_screen.dart';
import 'package:reel_ro/app/modules/search/search_screen.dart';
import 'package:reel_ro/utils/snackbar.dart';

import '../chat/chat_list.dart';
import '../homepage/homepage_screen.dart';
import '../single_feed/single_feed_screen.dart';
import 'navigation_bar_controller.dart';

class NavigationBarScreen extends StatelessWidget {
  NavigationBarScreen({Key? key}) : super(key: key);

  static final NavigationBarController controller =
      Get.put(NavigationBarController());
  final homepage = HomePageScreen();
  final profileScreen = ProfileScreen();
  static var searchScreen = SearchScreen();
  static RxBool isSelected = false.obs;
  static var singleScreen = SingleFeedScreen(null, null, 0, null);

  buildBottomNavigationMenu(context) {
    return Obx(() => MediaQuery(
        data: Get.mediaQuery.copyWith(textScaleFactor: 1.0),
        child: Container(
          height: 66,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
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
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.center,
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
                              color: Colors.white,
                              size: 30,
                            )
                          : const Icon(
                              Icons.home_outlined,
                              color: Colors.grey,
                              size: 28,
                            ),
                    ),
                    const Positioned(
                      top: 34,
                      right: 12,
                      child: Text(
                        'Home',
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  searchScreen.resetTop();
                  controller.changeTabIndex(1);
                },
                child: Stack(
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        isSelected.value = false;
                        searchScreen.resetTop();
                        controller.changeTabIndex(1);
                      },
                      icon: controller.tabIndex.value == 1
                          ? const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30,
                            )
                          : const Icon(
                              Icons.search_outlined,
                              color: Colors.grey,
                              size: 28,
                            ),
                    ),
                    const Positioned(
                      top: 34,
                      right: 7,
                      child: Text(
                        'Search',
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  controller.changeTabIndex(2);
                },
                child: Stack(
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        controller.changeTabIndex(2);
                      },
                      icon: controller.tabIndex.value == 2
                          ? const Icon(
                              Icons.card_giftcard,
                              color: Colors.white,
                              size: 30,
                            )
                          : const Icon(
                              Icons.card_giftcard_outlined,
                              color: Colors.grey,
                              size: 28,
                            ),
                    ),
                    const Positioned(
                      top: 35,
                      left: 2,
                      child: Text(
                        'Giveaway',
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  controller.changeTabIndex(3);
                },
                child: Stack(
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        controller.changeTabIndex(3);
                      },
                      icon: controller.tabIndex.value == 3
                          ? const Icon(
                              Icons.access_time_rounded,
                              color: Colors.white,
                              size: 30,
                            )
                          : const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                              size: 28,
                            ),
                    ),
                    const Positioned(
                      top: 34,
                      right: 0,
                      child: Text(
                        'Countdown',
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  profileScreen.resetTop();
                  controller.changeTabIndex(4);
                },
                child: Stack(
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        profileScreen.resetTop();
                        controller.changeTabIndex(4);
                      },
                      icon: controller.tabIndex.value == 4
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            )
                          : const Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                              size: 28,
                            ),
                    ),
                    const Positioned(
                      top: 34,
                      right: 11,
                      child: Text(
                        'Profile',
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                    )
                  ],
                ),
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
                  isSelected.value ? singleScreen : searchScreen,
                  GiveawayView(),
                  ChatList(),
                  profileScreen,
                ],
                index: controller.tabIndex.value,
              ),
            )));
  }
}
