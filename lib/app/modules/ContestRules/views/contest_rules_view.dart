import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/utils/colors.dart';

import '../../../../models/contest_model.dart';
import '../../../../repositories/giveaway_repository.dart';
import '../../../../widgets/loading.dart';
import '../../ContestDates/controllers/contest_dates_controller.dart';
import '../controllers/contest_rules_controller.dart';

class ContestRulesView extends GetView<ContestRulesController> {
  ContestRulesView({Key? key}) : super(key: key);
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(ContestDatesController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    Get.put(ContestRulesController());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contest Rules',
            style: TextStyle(fontSize: 14),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              )),
        ),
      body: FutureBuilder<List<ContestModel>>(
        future: _giveawayRepo.getContests(
            _controller.profileId!, _controller.token!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }
          if (snapshot.hasError) {
            printInfo(info: "getContests: ${snapshot.hasError}");
            return Container();
          }
          return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
            itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.contestrulesbrown,
                            AppColors.contestrulesligthbrown,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                      snapshot.data![index].contestName,
                            style: style.titleLarge!.copyWith(
                              color: AppColors.winnercardbrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                    Text(snapshot.data![index].rules.replaceAll(', ', '\n')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
