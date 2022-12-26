import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reel_ro/models/contest_model.dart';
import 'package:reel_ro/utils/colors.dart';

class ContestCard extends StatelessWidget {
  final ContestModel contest;
  const ContestCard({Key? key, required this.contest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Container(
      margin: const EdgeInsets.all(10),
      height: 270,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffEEC865),
            Color(0xffFFE654),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(contest.Contest.contest_name,
              style:
                  style.titleLarge!.copyWith(color: AppColors.winnercardbrown)),
          Image.network(
            // "https://reelro-image-bucket.s3.ap-south-1.amazonaws.com/inputs/" +
            contest.prizes.first.prize_image,
            fit: BoxFit.cover,
            width: 150,
            height: 90,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Prize', style: style.titleLarge),
              const SizedBox(width: 10),
              Text(
                contest.prizes.first.prize_name,
                style: style.headline5!.copyWith(
                  color: AppColors.winnercardpink,
                ),
              ),
            ],
          ),
          Text(
              'Contest ends on ${DateFormat("MMMM dd, yyyy").format(DateTime.parse(contest.Contest.end_date))}',
              style: style.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
