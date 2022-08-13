import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/app/modules/auth/sign_up/signup_screen.dart';
import 'package:reel_ro/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:reel_ro/app/modules/giveaway/views/giveaway_view.dart';
import 'package:reel_ro/app/modules/profile/profile_screen.dart';
import 'package:reel_ro/app/modules/search/search_screen.dart';
import 'package:reel_ro/app/modules/splash/splash_screen.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/loading.dart';

import '../../inbox_screen.dart';
import '../homepage/homepage_screen.dart';
import 'navigation_bar_controller.dart';

class NavigationBarScreen extends StatelessWidget {
  NavigationBarScreen({Key? key}) : super(key: key);

  final NavigationBarController controller = Get.put(NavigationBarController());

  buildBottomNavigationMenu(context) {
    controller.changeTabIndex(0);
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: controller.tabIndex.value == 0 ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.only(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      controller.changeTabIndex(0);
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
                  Text(
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
                  Text(
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
                  Text(
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
                  Text(
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
                  Text(
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
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: buildBottomNavigationMenu(context),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              HomePageScreen(),
              SearchScreen(),
              GiveawayView(),
              const InboxScreen(),
              ProfileScreen(),
            ],
          )),
    ));
  }
}
