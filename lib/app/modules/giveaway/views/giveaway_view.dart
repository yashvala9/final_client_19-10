import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/modules/entry_count/views/entry_count_view.dart';
import 'package:reel_ro/app/modules/referrals/views/referrals_view.dart';
import 'package:reel_ro/utils/colors.dart';

import '../controllers/giveaway_controller.dart';

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/entrycount.png',
                      ),
                      Column(
                        children: const [
                          Center(
                            child: Text(
                              '\nEarned Entries',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                          Center(
                            child: Text(
                              '1246',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                listTileWidget('enter 1', 'Entry Count', EntryCountView()),
                listTileWidget('referral', 'Referrals', ReferralsView()),
                listTileWidget('trophy', 'Winners', ReferralsView()),
                listTileWidget('badge', 'Contest Dates', ReferralsView()),
                listTileWidget('book', 'Contest Rules', ReferralsView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget listTileWidget(String filename, String text, var pageName) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
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
        Get.to(pageName);
      },
    ),
  );
}

