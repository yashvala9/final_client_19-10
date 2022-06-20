import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/custom_button.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import '../../../routes/app_routes.dart';
import '../auth_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final RxBool isPassWordVisible = false.obs;
    final RxBool isRepeatPassWordVisible = false.obs;

    final _emailController = TextEditingController();
    final _userNameController = TextEditingController();
    final _countryCodeController = TextEditingController();
    final _mobileController = TextEditingController();
    final _passwordController = TextEditingController();
    final _repeatPasswordController = TextEditingController();

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
                            : Get.height * 0.05,
                        bottom: Get.height * 0.015,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.titleLarge,
                            ),
                            SizedBox(height: Get.height * 0.015),
                            Text(
                              'Username',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge,
                            ),
                            SizedBox(height: Get.height * 0.01),
                            TextFormField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                hintText: 'jamesbond123',
                                prefixIcon: Icon(
                                  CupertinoIcons.person_solid,
                                  color:
                                      AppColors.headline5Color.withOpacity(.5),
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                return value!.isEmpty
                                    ? 'Username is required'
                                    : null;
                              },
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              'Email',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge,
                            ),
                            SizedBox(height: Get.height * 0.01),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email_rounded,
                                  color:
                                      AppColors.headline5Color.withOpacity(.5),
                                ),
                              ),
                              validator: (value) {
                                return value!.isEmpty
                                    ? 'Email is required'
                                    : '';
                              },
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text('Mobile Number',
                                textScaleFactor: Get.textScaleFactor,
                                style: style.labelLarge),
                            SizedBox(height: Get.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _countryCodeController,
                                    decoration: const InputDecoration(
                                      hintText: '+44',
                                      counterText: '',
                                    ),
                                    maxLength: 2,
                                  ),
                                ),
                                 SizedBox(
                                  width: Get.width * 0.03,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _mobileController,
                                    decoration: InputDecoration(
                                      hintText: '9876543210',
                                      counterText: '',
                                      prefixIcon: Icon(
                                        Icons.phone_android_sharp,
                                        color: AppColors.headline5Color
                                            .withOpacity(.5),
                                      ),
                                    ),
                                    maxLength: 10,
                                    validator: (value) {
                                    return  value!.isEmpty
                                          ? 'Mobile number is required'
                                          : null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              'Password',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge
                            ),
                            SizedBox(height: Get.height * 0.015),
                            Obx(
                              () => TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  suffixIcon: GestureDetector(
                                    onTap: () => isPassWordVisible.value =
                                        !isPassWordVisible.value,
                                    child: isPassWordVisible.value 
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
                                 return value!.isEmpty ? 'Password is required' : null;
                                },
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              'Repeat Password',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge?.copyWith(
                                color: AppColors.labelLarge,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.015),
                            Obx(
                              () => TextFormField(
                                controller: _repeatPasswordController,
                                decoration: InputDecoration(
                                  hintText: 'Repeat Password',
                                  suffixIcon: GestureDetector(
                                    onTap: () => isRepeatPassWordVisible.value =
                                        !isRepeatPassWordVisible.value,
                                    child: isRepeatPassWordVisible.value
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
                                 return value!.isEmpty ? 'Password is required' : null;
                                },
                              ),
                            ),
                            SizedBox(height: Get.height * 0.03),
                            MyElevatedButton(
                              buttonText: 'Sign Up',
                              onPressed: () =>
                                  Get.toNamed(AppRoutes.createProfile),
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
                                        .withOpacity(.2),
                                  ),
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
                                        .withOpacity(.2),
                                  ),
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
                                  Get.toNamed(AppRoutes.login);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Already have an account?',
                                    style: style.bodyMedium?.copyWith(
                                      color: AppColors.subtitle2Color
                                          .withOpacity(.8),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign in',
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
