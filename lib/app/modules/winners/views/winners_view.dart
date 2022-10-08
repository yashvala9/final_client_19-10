import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/winner_model.dart';
import 'package:reel_ro/utils/assets.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../../../widgets/loading.dart';
import '../controllers/winners_controller.dart';
import 'widgets/winnercard_widget.dart';
import 'widgets/winnerheaderimage_widget.dart';

class WinnersView extends GetView<WinnersController> {
  WinnersView({Key? key}) : super(key: key);
  final _giveawayRepo = GiveawayRepository();
  final _controller = Get.put(WinnersController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Winners',
          style: TextStyle(fontSize: 17),
        ),
        elevation: 2,
      ),
      backgroundColor: theme.colorScheme.primary,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                Assets.winnerScreenBackground,
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const WinnerHeaderImage(),
            FutureBuilder<List<WinnerModel>>(
              future: _giveawayRepo.getWinners(
                  _controller.profileId!, _controller.token!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Loading();
                }
                if (snapshot.hasError) {
                  printInfo(info: "getWinners: ${snapshot.hasError}");
                  return Container();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return WinnerCardWidget(winner: snapshot.data![index]);
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
