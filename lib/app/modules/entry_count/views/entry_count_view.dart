import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/modules/ads_history/ads_history_view.dart';
import 'package:reel_ro/utils/colors.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../controllers/entry_count_controller.dart';

class EntryCountView extends GetView<EntryCountController> {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(EntryCountController());

  EntryCountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Entry Count',
            style: TextStyle(fontSize: 17),
          ),
        ),
        // backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Image.asset(
                'assets/Frame.png',
              ),
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
                          "Earned Entries",
                          style: style.titleMedium,
                        ),
                        FutureBuilder<String>(
                            future: _giveawayRepo.getTotalEntryCountByUserId(
                                _controller.profileId!, _controller.token!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text(
                                  "0",
                                  style: style.titleLarge
                                      ?.copyWith(color: AppColors.red),
                                );
                              }
                              if (snapshot.hasError) {
                                printInfo(
                                    info:
                                        "getTotalEntryCountByUserId: ${snapshot.hasError}");
                                return Container();
                              }
                              return Text(
                                snapshot.data.toString(),
                                style: style.titleLarge
                                    ?.copyWith(color: AppColors.red),
                              );
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width * 0.43,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Image.asset(
                              'assets/advertising.png',
                              height: 40,
                            ),
                          ),
                          FutureBuilder<String>(
                              future: _giveawayRepo.getAdsEntryCountByUserId(
                                  _controller.profileId!, _controller.token!),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  printInfo(
                                      info:
                                          "getAdsEntryCountByUserId: ${snapshot.hasError}");
                                  return Container();
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.hasData
                                        ? snapshot.data.toString()
                                        : "0",
                                    style: style.titleLarge
                                        ?.copyWith(color: AppColors.red),
                                  ),
                                );
                              }),
                          Text(
                            "Ad Entries",
                            style: style.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.43,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Image.asset(
                              'assets/referral.png',
                              height: 40,
                            ),
                          ),
                          FutureBuilder<String>(
                              future:
                                  _giveawayRepo.getReferralsEntryCountByUserId(
                                      _controller.profileId!,
                                      _controller.token!),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  printInfo(
                                      info:
                                          "getReferralsEntryCountByUserId: ${snapshot.hasError}");
                                  return Container();
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.hasData
                                        ? snapshot.data.toString()
                                        : "0",
                                    style: style.titleLarge
                                        ?.copyWith(color: AppColors.red),
                                  ),
                                );
                              }),
                          Text(
                            "Referral Entries",
                            style: style.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: InkWell(
                onTap: () {
                  Get.to(() => AdsHistoryView());
                },
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
