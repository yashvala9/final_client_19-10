import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/splash/splash_controller.dart';

import '../../../utils/assets.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({Key? key}) : super(key: key);
  final _controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.asset(
                Assets.reelRo,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            /*  Text(
              "Version : ${controller.packageInfo.version}",
              textScaleFactor: Get.textScaleFactor,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
            ), */
            SizedBox(
              height: Get.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
