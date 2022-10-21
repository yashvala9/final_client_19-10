import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';
import 'package:reel_ro/app/modules/ContestDates/views/contest_dates_view.dart';
import 'package:reel_ro/app/modules/ContestRules/views/contest_rules_view.dart';
import 'package:reel_ro/app/modules/entry_count/views/entry_count_view.dart';
import 'package:reel_ro/app/modules/referrals/views/referrals_view.dart';
import 'package:reel_ro/utils/colors.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../../../widgets/loading.dart';
import '../../winners/views/winners_view.dart';
import '../controllers/giveaway_controller.dart';

class GiveawayView extends GetView<GiveawayController> {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(GiveawayController());
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Give Away',
              style: style.titleMedium,
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Stack(children: [
                  SizedBox(
                    height: Get.height * 0.2,
                    width: Get.width,
                    child: Image.asset(
                      'assets/Bg.png',
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          '\nEarned Entries',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      FutureBuilder<String>(
                        future: _giveawayRepo.getTotalEntryCountByUserId(
                            _controller.profileId!, _controller.token!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            );
                          }
                          if (snapshot.hasError) {
                            printInfo(
                                info:
                                    "getTotalEntryCountByUserIdError: ${snapshot.hasError}");
                            return Container();
                          }
                          return Text(
                            snapshot.data.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ]),
                listTileWidget('enter 1', 'Entry Count', EntryCountView()),
                listTileWidget('referral', 'Referrals', ReferralsView()),
                listTileWidget('trophy', 'Winners', WinnersView()),
                listTileWidget('badge', 'Contest Dates', ContestDatesView()),
                listTileWidget('book', 'Contest Rules', ContestRulesView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget listTileWidget(String filename, String text, Widget pageName) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: const EdgeInsets.all(8.0),
      leading: SizedBox(
        width: 70,
        child: Image.asset(
          'assets/$filename.png',
        ),
      ),
      title: Text(text),
      tileColor: Colors.white,
      onTap: () {
        Get.to(() => pageName);
      },
    ),
  );
}
