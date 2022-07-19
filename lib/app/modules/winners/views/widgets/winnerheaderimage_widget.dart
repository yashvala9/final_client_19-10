import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';

class WinnerHeaderImage extends StatelessWidget {
  const WinnerHeaderImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Container(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      margin: const EdgeInsets.all(8.0),
      height: 223,
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(1),
        ),
        image: DecorationImage(
          image: AssetImage(Assets.winnerHeaderImage),
        ),
      ),
      child: Text(
        'Mega Prize Winner',
        style: style.headline5!.copyWith(
          color: AppColors.whiteappbar,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
