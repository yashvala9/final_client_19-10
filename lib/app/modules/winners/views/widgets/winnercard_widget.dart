import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';
import 'package:reel_ro/utils/colors.dart';

class WinnerCardWidget extends StatelessWidget {
  final WinnerList winnerList;
  const WinnerCardWidget({
    Key? key,
    required this.winnerList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Container(
        height: 223,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 222, 137, 0.9),
                Color.fromRGBO(245, 227, 124, 0.9),
              ],
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              winnerList.title!,
              style: style.subtitle1,
            ),
            Text(
              winnerList.prize!,
              style: style.titleLarge!.copyWith(
                color: AppColors.winnercardpink,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 105,
              width: Get.size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: Color.fromRGBO(255, 238, 194, 0.9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(winnerList.imageurl!),
                    radius: 25,
                  ),
                  Text(
                    winnerList.userName!,
                    style: style.subtitle1
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
