import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/contest_dates_controller.dart';
import 'widgets/contestcard_widget.dart';

class ContestDatesView extends GetView<ContestDatesController> {
  ContestDatesView({Key? key}) : super(key: key);
  final _controller = Get.put<ContestDatesController>(ContestDatesController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contest Dates',
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
      body: Center(
        child: Obx(() => !controller.isLoading.value
            ? ListView.builder(
                itemCount: controller.contestDatesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContestCard(
                    contestDates: controller.contestDatesList[index],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                  backgroundColor: Colors.red,
                ),
              )),
      ),
    );
  }
}
