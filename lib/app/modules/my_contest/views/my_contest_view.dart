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
        title: Text(
          contestModel.contest_name,
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
        onPressed: () async {
          final val = await Get.dialog(AlertDialog(
            title: const Text("Are you sure you want to delete this contest?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
            ],
          ));
          if (val != null) {
            _controller.deleteContest(contestModel.id);
          }
        },
      ),
    );
  }
}
