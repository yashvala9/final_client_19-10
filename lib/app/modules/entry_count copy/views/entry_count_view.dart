import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/modules/giveaway/controllers/giveaway_controller.dart';
import 'package:reel_ro/utils/colors.dart';

class GiveawayView extends GetView<GiveawayController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Give Away',
            style: style.titleMedium,
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Image.asset(
                  'assets/Frame.png',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Image.asset('assets/banner.png'),
                      Positioned(
                        right: Get.width * 0.3,
                        top: Get.height * 0.05,
                        child: Column(
                          children: [
                            Text(
                              "Total Entries",
                              style: style.titleMedium,
                            ),
                            Text(
                              "1440",
                              style: style.titleLarge
                                  ?.copyWith(color: AppColors.red),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.45,
                        height: Get.height * 0.25,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Image.asset(
                                  'assets/advertising.png',
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "336",
                                  style: style.titleLarge
                                      ?.copyWith(color: AppColors.red),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Ad Entries",
                                  style: style.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.45,
                        height: Get.height * 0.25,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Image.asset(
                                  'assets/referral.png',
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "210",
                                  style: style.titleLarge
                                      ?.copyWith(color: AppColors.red),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Referral Entries",
                                  style: style.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: SizedBox(
                      height: Get.height * 0.15,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Image.asset(
                              'assets/youtube.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              "Ad History",
                              style: style.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
