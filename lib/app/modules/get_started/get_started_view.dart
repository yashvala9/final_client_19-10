import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';

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
                  padding: EdgeInsets.all(Get.width * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Button(
                        onTap: (){},
                        style: style,
                        text: 'Continue with Facebook',
                        iconImage: Assets.facebookIcon,
                      ),
                      const Divider(),
                      Button(
                        onTap: (){},
                        style: style,
                        text: 'Continue with Google',
                        iconImage: Assets.googleIcon,
                      ),
                      const Divider(),
                      Button(
                        onTap: () => Get.toNamed(AppRoutes.login),
                        style: style,
                        text: 'Continue with Email',
                        iconImage: Assets.emailIcon,
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

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.style,
    required this.text,
    required this.iconImage,
    required this.onTap,
  }) : super(key: key);

  final TextTheme style;
  final String text;
  final String iconImage;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width * 0.8,
        padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.02,
          horizontal: Get.width * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(iconImage, width: Get.width * 0.08),
            SizedBox(width: Get.width * 0.08),
            Text(
              text,
              style: style.bodyMedium?.copyWith(
                color: AppColors.buttonTextColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
