import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/modules/ContestDates/views/contest_dates_view.dart';
import 'package:reel_ro/app/modules/ContestRules/views/contest_rules_view.dart';
import 'package:reel_ro/app/modules/entry_count/views/entry_count_view.dart';
import 'package:reel_ro/app/modules/referrals/views/referrals_view.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../winners/views/winners_view.dart';
import '../controllers/giveaway_controller.dart';

class GiveawayView extends GetView<GiveawayController> {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(GiveawayController());

  GiveawayView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    int endTime = DateTime.now().millisecondsSinceEpoch + 5000 * 30 * 60 * 24;

    return Scaffold(
      backgroundColor: Colors.grey[350],
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
            child: Container(
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
                  listTileWidget(
                      'book', 'Contest Rules', const ContestRulesView()),
                  SizedBox(
                    height: 250,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 70,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[700]),
                      child: Center(
                        child: CountdownTimer(
                          widgetBuilder: (context, time) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800]!,
                                          border: Border.all(
                                            color: Colors.grey[800]!,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Center(
                                            child: Text(
                                          time!.days.toString(),
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                      Text('Day')
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Center(
                                            child: Text(time.hours.toString())),
                                      ),
                                      Text('Hour')
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Center(
                                            child: Text(time.min.toString())),
                                      ),
                                      Text('Minute')
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Center(
                                            child: Text(time.sec.toString())),
                                      ),
                                      Text('Second')
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          endTime: endTime,
                          textStyle: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget listTileWidget(String filename, String text, Widget pageName) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 04.0),
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
