import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';

import '../../../../models/contest_model.dart';
import '../../../../widgets/loading.dart';
import '../controllers/my_contest_controller.dart';
import 'widgets/contestcard_widget.dart';

class MyContestView extends GetView<MyContestController> {
  MyContestView(this.contestModel, {Key? key}) : super(key: key);
  final ContestModel contestModel;
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(MyContestController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Contest',
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
      body: ContestCard(
        contest: contestModel,
      ),
    );
  }
}

                                    // FutureBuilder<String>(
                                    //   future: _giveawayRepo
                                    //       .getReferralsEntryCountByUserId(
                                    //           _controller.profileId!,
                                    //           _controller.token!),
                                    //   builder: (context, snapshot) {
                                    //     if (!snapshot.hasData) {
                                    //       return const Loading();
                                    //     }
                                    //     if (snapshot.hasError) {
                                    //       printInfo(
                                    //           info:
                                    //               "getReferralsEntryCountByUserId: ${snapshot.hasError}");
                                    //       return Container();
                                    //     }
                                    //     return Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Text(
                                    //         snapshot.data.toString(),
                                    //         style: style.titleLarge?.copyWith(
                                    //             color: AppColors.red),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),