import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/custom_button.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Image.asset(
                Assets.getStartedBackground,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: Get.height * 0.5,
                left: Get.width * 0.25,
                child: Image.asset(
                  Assets.reelroImageWhite,
                  width: Get.width * 0.5,
                ),
              ),
              Positioned(
                bottom: Get.height * 0.05,
                child: Padding(
                  padding: EdgeInsets.all(Get.width * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Button(
                        onTap: (){},
                        style: style,
                        color: Colors.white,
                        text: 'Continue with Facebook',
                        iconImage: Assets.facebookIcon,
                        buttonTextColor: AppColors.buttonTextColor2,
                      ),
                      const Divider(),
                      Button(
                        onTap: (){},
                        style: style,
                        color: Colors.white,
                        text: 'Continue with Google',
                        iconImage: Assets.googleIcon,
                        buttonTextColor: AppColors.buttonTextColor2,
                      ),
                      const Divider(),
                      Button(
                        onTap: () => Get.toNamed(AppRoutes.login),
                        style: style,
                        border: Border.all(color: AppColors.borderColor),
                        text: 'Continue with Email',
                        iconImage: Assets.emailIcon,
                        buttonTextColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


