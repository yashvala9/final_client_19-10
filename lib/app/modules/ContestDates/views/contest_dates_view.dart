import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';

import '../../../../models/contest_model.dart';
import '../../../../widgets/loading.dart';
import '../controllers/contest_dates_controller.dart';
import 'widgets/contestcard_widget.dart';

class ContestDatesView extends GetView<ContestDatesController> {
  ContestDatesView({Key? key}) : super(key: key);
  final _giveawayRepo = GiveawayRepository();
  final _controller = Get.put(ContestDatesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contest Dates',
            style: TextStyle(fontSize: 17),
          ),
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
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ContestCard(
                  contest: snapshot.data![index],
                );
              },
            );
          },
        ));
  }
}
