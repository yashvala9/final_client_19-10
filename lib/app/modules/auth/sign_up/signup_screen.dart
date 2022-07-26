import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/utils/snackbar.dart';
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
    return GetBuilder<AuthController>(
      builder: (_) => Scaffold(
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
                              SizedBox(height: Get.height * 0.02),
                              Text('Username',
                                  textScaleFactor: Get.textScaleFactor,
                                  style: style.labelLarge),
                              SizedBox(height: Get.height * 0.01),
                              TextFormField(
                                enabled: !_controller.loading,
                                decoration: InputDecoration(
                                  hintText: 'jamesbond123',
                                  prefixIcon: Icon(
                                    CupertinoIcons.person_solid,
                                    color: AppColors.headline5Color
                                        .withOpacity(.5),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[a-zA-Z0-9]')),
                                ],
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Username is required'
                                      : null;
                                },
                                onSaved: (v) => _controller.userName = v!,
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Text(
                                'Email',
                                textScaleFactor: Get.textScaleFactor,
                                style: style.labelLarge,
                              ),
                              SizedBox(height: Get.height * 0.01),
                              TextFormField(
                                enabled: !_controller.loading,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email_rounded,
                                    color: AppColors.headline5Color
                                        .withOpacity(.5),
                                  ),
                                ),
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Email is required'
                                      : !value.isEmail
                                          ? "Invalid Email"
                                          : null;
                                },
                                onSaved: (v) => _controller.email = v!,
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Text('Password',
                                  textScaleFactor: Get.textScaleFactor,
                                  style: style.labelLarge),
                              SizedBox(height: Get.height * 0.015),
                              TextFormField(
                                  enabled: !_controller.loading,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    suffixIcon: GestureDetector(
                                        onTap: () => _controller.obsecure =
                                            !_controller.obsecure,
                                        child: Icon(
                                          _controller.obsecure
                                              ? Icons.visibility_sharp
                                              : Icons.visibility_off_sharp,
                                          color: AppColors.headline5Color
                                              .withOpacity(.5),
                                        )),
                                  ),
                                  obscureText: !_controller.obsecure,
                                  onSaved: (v) => _controller.password = v!,
                                  validator: (value) => value!.isEmpty
                                      ? 'Password is required'
                                      : value.length < 8
                                          ? "Password should be greater than 8 words"
                                          : null),
                              SizedBox(height: Get.height * 0.02),
                              Text(
                                'Repeat Password',
                                textScaleFactor: Get.textScaleFactor,
                                style: style.labelLarge?.copyWith(
                                  color: AppColors.labelLarge,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.015),
                              TextFormField(
                                  enabled: !_controller.loading,
                                  decoration: InputDecoration(
                                    hintText: 'Repeat Password',
                                    suffixIcon: GestureDetector(
                                      onTap: () => _controller.obsecure2 =
                                          !_controller.obsecure2,
                                      child: Icon(
                                        _controller.obsecure2
                                            ? Icons.visibility_sharp
                                            : Icons.visibility_off_sharp,
                                        color: AppColors.headline5Color
                                            .withOpacity(.5),
                                      ),
                                    ),
                                  ),
                                  obscureText: !_controller.obsecure2,
                                  onSaved: (v) =>
                                      _controller.repeatPassword = v!,
                                  validator: (value) => value!.isEmpty
                                      ? 'Password is required'
                                      : value.length < 8
                                          ? "Password should be greater than 8 words"
                                          : null),
                              SizedBox(height: Get.height * 0.03),
                              _controller.loading
                                  ? const Loading()
                                  : MyElevatedButton(
                                      buttonText: 'Sign Up',
                                      onPressed: () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        _formKey.currentState!.save();
                                        if (_controller.password !=
                                            _controller.repeatPassword) {
                                          showSnackBar(
                                              "Repeat password doees not match!",
                                              color: Colors.red);
                                          return;
                                        }
                                        _controller.signup();
                                      }),
                              SizedBox(height: Get.height * 0.03),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}
