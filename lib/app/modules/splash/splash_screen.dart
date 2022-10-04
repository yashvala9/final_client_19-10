import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                Assets.reelRo,
                width: Get.width * 0.5,
              ),
            ),
            // Text(
            //   "Version : ${_controller.packageInfo.version}",
            //   textScaleFactor: Get.textScaleFactor,
            //   textAlign: TextAlign.center,
            //   style: Theme.of(context).textTheme.subtitle2?.copyWith(
            //         color: Theme.of(context).disabledColor,
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}
