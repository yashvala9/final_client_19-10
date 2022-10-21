import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/utils/snackbar.dart';
import '../../../../models/contest_model.dart';
import '../../account_settings/views/account_settings_view.dart';
import '../controllers/follower_picker_controller.dart';

class FollowerPickerView extends GetView<FollowerPickerController> {
  FollowerPickerView(this.contestModel, {Key? key}) : super(key: key);

  ContestModel contestModel;

  final _controller = Get.put(FollowerPickerController());

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Image.asset(
            "assets/Left Arrow Icon.png",
            height: 18,
            width: 10.21,
          ),
        ),
        title: Text(
          "Random Follower Picker",
          style: style
              .titleMedium, /*TextStyle(
            color: Color.fromRGBO(22, 23, 34, 1),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),*/
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/Background.png",
            ),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Image.asset(
              "assets/Winner.png",
              height: 300,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: colorSchema.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Text(
                    "Pick a random follower",
                    style: style
                        .headline6, /*TextStyle(
                        color: Color.fromRGBO(119, 79, 0, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w600),*/
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    "You can randomly choose the contest winner",
                    style: style
                        .titleMedium, /*TextStyle(
                        color: Color.fromRGBO(22, 23, 34, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),*/
                  ),
                  Image.asset(
                    "assets/Winner 1.png",
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () async {
                        debugPrint(
                            '2121 contestModel.id.toString() ${contestModel.id.toString()}');
                        var v = await _controller
                            .setRandomWinner(contestModel.id.toString());
                        Get.off(FollowerPickerWinnerView(v));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(234, 67, 89, 1),
                      ),
                      child: Text(
                        "Start",
                        style: style
                            .titleMedium, /*TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),*/
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class FollowerPickerWinnerView extends GetView<FollowerPickerController> {
  FollowerPickerWinnerView(this.winnerName, {Key? key}) : super(key: key);

  String winnerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Image.asset(
            "assets/Left Arrow Icon.png",
            height: 18,
            width: 10.21,
          ),
        ),
        title: const Text(
          "Random Follower Picker",
          style: TextStyle(
            color: Color.fromRGBO(22, 23, 34, 1),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 694.9,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/Background.png"),
              ),
            ),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  height: 308,
                  width: 285,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Winner.png"),
                    ),
                  ),
                ),
                Container(
                  height: 370,
                  width: 376,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(239, 192, 70, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Text(
                        "Winner Name: $winnerName",
                        style: TextStyle(
                            color: Color.fromRGBO(119, 79, 0, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      // Image.asset(
                      //   "assets/Winner 2.png",
                      //   height: 250,
                      //   width: 250,
                      // ),
                      SizedBox(
                        height: 40,
                        width: 160,
                        child: ElevatedButton(
                          onPressed: () {
                            showSnackBar('Winner has been Informed!');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(234, 67, 89, 1),
                          ),
                          child: const Text(
                            "Inform Winner",
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
