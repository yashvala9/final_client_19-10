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
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          backgroundColor: Color.fromARGB(255, 255, 229, 84),
          title: const Text(
            'Contest Dates',
            style: TextStyle(fontSize: 17, color: Colors.black),
          ),
          elevation: 2,
        ),
        body: FutureBuilder<List<ContestModel>>(
          future: _giveawayRepo.getContests(
              _controller.profileId!, _controller.token!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
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
