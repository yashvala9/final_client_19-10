import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/modules/ContestDates/views/contest_dates_view.dart';
import 'package:reel_ro/app/modules/ContestRules/views/contest_rules_view.dart';
import 'package:reel_ro/app/modules/entry_count/views/entry_count_view.dart';
import 'package:reel_ro/app/modules/referrals/views/referrals_view.dart';
import 'package:reel_ro/utils/colors.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../winners/views/winners_view.dart';
import '../controllers/giveaway_controller.dart';

class GiveawayView extends GetView<GiveawayController> {
  final _giveawayRepo = GiveawayRepository();
  final _controller = Get.put(GiveawayController());

  GiveawayView({Key? key}) : super(key: key);
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
                Container(
                  height: Get.height * 0.2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xffEA4359),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Column(
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
                ),
                listTileWidget('enter 1', 'Entry Count', EntryCountView()),
                listTileWidget('referral', 'Referrals', ReferralsView()),
                listTileWidget('trophy', 'Winners', WinnersView()),
                listTileWidget('badge', 'Contest Dates', ContestDatesView()),
                listTileWidget(
                    'book', 'Contest Rules', const ContestRulesView()),
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
      tileColor: Colors.grey[200],
      onTap: () {
        Get.to(() => pageName);
      },
    ),
  );
}
