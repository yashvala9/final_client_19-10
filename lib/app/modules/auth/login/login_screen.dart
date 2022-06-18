import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/custom_button.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import '../auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final RxBool isValidEmail = false.obs;
    final RxBool isPassWordVisible = false.obs;

    return Scaffold(
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Image.asset(Assets.loginScreenBackground),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Get.width * 0.05,
                        right: Get.width * 0.05,
                        top: isKeyboardVisible
                            ? Get.height * 0.01
                            : Get.height * 0.15,
                        bottom: Get.height * 0.025,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.titleLarge,
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Image.asset(
                              Assets.reelRoImage,
                              width: Get.width * 0.35,
                            ),
                            SizedBox(height: Get.height * 0.03),
                            Text(
                              'Username',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge?.copyWith(
                                color: AppColors.labelLarge,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.015),
                            Obx(
                              () => TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'abc@gmail.com',
                                  suffixIcon:
                                      isValidEmail.value == !isValidEmail.value
                                          ? const Icon(
                                              Icons.check_box,
                                              color: AppColors.lightGreen,
                                            )
                                          : null,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  value!.isEmpty ? 'Email is required' : '';
                                  value.isEmail
                                      ? isValidEmail.value = true
                                      : isValidEmail.value = false;
                                },
                              ),
                            ),
                            SizedBox(height: Get.height * 0.03),
                            Text(
                              'Password',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge?.copyWith(
                                color: AppColors.labelLarge,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.015),
                            Obx(
                              () => TextFormField(
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
                                  value!.isEmpty ? 'Password is required' : '';
                                },
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                textScaleFactor: Get.textScaleFactor,
                                style: style.bodyMedium?.copyWith(
                                  color: AppColors.lightBlack.withOpacity(.5),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            MyElevatedButton(
                              buttonText: 'Login',
                              onPressed: () {},
                            ),
                            SizedBox(height: Get.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Divider(
                                      indent: Get.width * 0.04,
                                      endIndent: Get.width * 0.04,
                                      color: AppColors.subtitle1Color
                                          .withOpacity(.2)),
                                ),
                                Text(
                                  'or login with',
                                  textScaleFactor: Get.textScaleFactor,
                                  style: style.bodyMedium?.copyWith(
                                    color: AppColors.subtitle2Color
                                        .withOpacity(.6),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                      indent: Get.width * 0.04,
                                      endIndent: Get.width * 0.04,
                                      color: AppColors.subtitle1Color
                                          .withOpacity(.2)),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Button(
                                  style: style,
                                  text: 'Google',
                                  border: Border.all(
                                    color: AppColors.textFieldColor,
                                  ),
                                  iconImage: Assets.googleIcon,
                                  onTap: () {},
                                  color: AppColors.lightGrey,
                                  width: Get.width * 0.42,
                                  space: Get.width * 0.04,
                                ),
                                Button(
                                  style: style,
                                  text: 'Facebook',
                                  border: Border.all(
                                    color: AppColors.textFieldColor,
                                  ),
                                  iconImage: Assets.facebookIcon,
                                  onTap: () {},
                                  color: AppColors.lightGrey,
                                  width: Get.width * 0.42,
                                  space: Get.width * 0.04,
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.signUp);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Don\'t have account?',
                                    style: style.bodyMedium?.copyWith(
                                      color: AppColors.subtitle2Color
                                          .withOpacity(.8),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign up',
                                        style: style.bodyMedium?.copyWith(
                                          color: AppColors.lightOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
        },
      ),
    );
  }
}
