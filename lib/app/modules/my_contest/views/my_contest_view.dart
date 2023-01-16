import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../models/contest_model.dart';
import '../controllers/my_contest_controller.dart';
import 'widgets/contestcard_widget.dart';

class MyContestView extends GetView<MyContestController> {
  MyContestView(this.contestModel, {Key? key}) : super(key: key);
  final ContestModel contestModel;
  final _controller = Get.put(MyContestController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          contestModel.contest_name!,
          style: const TextStyle(fontSize: 14),
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
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
            ],
          ));
          if (val != null) {
            _controller.deleteContest(contestModel.id!);
          }
        },
      ),
    );
  }
}
