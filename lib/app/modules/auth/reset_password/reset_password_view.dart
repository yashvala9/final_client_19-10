import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;

    final _passwordController = TextEditingController();
    final _repeatPasswordController = TextEditingController();

    final RxBool isPassWordVisible = false.obs;
    final RxBool isRepeatPassWordVisible = false.obs;

    return Scaffold(
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: Get.width * 0.05,
                  right: Get.width * 0.05,
                  top:
                      isKeyboardVisible ? Get.height * 0.04 : Get.height * 0.35,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Password',
                        textScaleFactor: Get.textScaleFactor,
                        style: style.headlineSmall?.copyWith(
                          color: AppColors.headline5Color,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        'Reset your password to recovery &\nlogin to your account.',
                        textScaleFactor: Get.textScaleFactor,
                        style: style.bodyLarge?.copyWith(
                          color: AppColors.subtitle2Color.withOpacity(.6),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.025),
                      Obx(
                        () => TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () => isPassWordVisible.value =
                                  !isPassWordVisible.value,
                              child: isPassWordVisible.value == true
                                  ? Icon(
                                      Icons.visibility_sharp,
                                      color: AppColors.headline5Color
                                          .withOpacity(.5),
                                    )
                                  : Icon(
                                      Icons.visibility_off_sharp,
                                      color: AppColors.headline5Color
                                          .withOpacity(.5),
                                    ),
                            ),
                          ),
                          obscureText: !isPassWordVisible.value,
                          validator: (value) {
                            return value!.isEmpty ? 'Password is required' : '';
                          },
                        ),
                      ),
                      SizedBox(height: Get.height * 0.025),
                      Obx(
                        () => TextFormField(
                          controller: _repeatPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Repeat Password',
                            suffixIcon: GestureDetector(
                              onTap: () => isRepeatPassWordVisible.value =
                                  !isRepeatPassWordVisible.value,
                              child: isRepeatPassWordVisible.value == true
                                  ? Icon(
                                      Icons.visibility_sharp,
                                      color: AppColors.headline5Color
                                          .withOpacity(.5),
                                    )
                                  : Icon(
                                      Icons.visibility_off_sharp,
                                      color: AppColors.headline5Color
                                          .withOpacity(.5),
                                    ),
                            ),
                          ),
                          obscureText: !isPassWordVisible.value,
                          validator: (value) {
                            return value!.isEmpty ? 'Password is required' : '';
                          },
                        ),
                      ),
                      SizedBox(height: Get.height * 0.03),
                      MyElevatedButton(
                        buttonText: 'Change',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
