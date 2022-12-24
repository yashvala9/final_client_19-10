import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
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
                  const SizedBox(
                    height: 25,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Container(
                  //     width: Get.width,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.black,
                  //       gradient: const LinearGradient(
                  //           colors: [
                  //             Color.fromARGB(255, 0, 64, 255),
                  //             Color(0xFF00CCFF),
                  //           ],
                  //           begin: FractionalOffset(0.0, 0.0),
                  //           end: FractionalOffset(1.0, 0.0),
                  //           stops: [0.0, 1.0],
                  //           tileMode: TileMode.clamp),
                  //     ),
                  //     child: Center(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(12.0),
                  //         child: CountdownTimer(
                  //           widgetBuilder: (context, time) {
                  //             return Center(
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   timeBox(time!.days.toString(), 'Day'),
                  //                   colon(),
                  //                   timeBox(time.hours.toString(), 'Hour'),
                  //                   colon(),
                  //                   timeBox(time.min.toString(), 'Minute'),
                  //                   colon(),
                  //                   timeBox(time.sec.toString(), 'Second'),
                  //                 ],
                  //               ),
                  //             );
                  //           },
                  //           endTime: endTime,
                  //           textStyle: const TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column colon() {
    return Column(
      children: const [
        Text(':', style: TextStyle(fontSize: 28, color: Colors.white)),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget timeBox(String time, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300]!,
                border: Border.all(
                  color: Colors.grey[100]!,
                  width: 2.0,
                ),
              ),
              child: Center(
                  child: Text(
                time,
                style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

Widget listTileWidget(String filename, String text, Widget pageName) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
    child: ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: const EdgeInsets.all(16.0),
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
