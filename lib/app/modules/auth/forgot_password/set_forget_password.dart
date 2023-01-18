import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/auth_controller.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/loading.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/my_elevated_button.dart';

class SetForgetPassword extends StatelessWidget {
  final String email;
  final String token;
  SetForgetPassword({Key? key, required this.email, required this.token})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;

    return GetBuilder<AuthController>(
      builder: (_) => Scaffold(
        body: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.07,
                    vertical: Get.height * 0.12,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.4,
                        width: Get.width,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.none,
                            child: Image.asset(
                              Assets.lockImage,
                              width: Get.width * 0.5,
                              height: Get.width * 0.5,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'New Password',
                        textScaleFactor: Get.textScaleFactor,
                        style: style.headlineSmall,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        'Reset your password to recovery & login to your account.',
                        textAlign: TextAlign.center,
                        textScaleFactor: Get.textScaleFactor,
                        style: style.bodyLarge?.copyWith(
                          color: AppColors.subtitle2Color.withOpacity(.6),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'New Password',
                                  suffixIcon: GestureDetector(
                                      onTap: () => _controller.obsecure =
                                          !_controller.obsecure,
                                      child: Icon(
                                        _controller.obsecure
                                            ? Icons.visibility_off_sharp
                                            : Icons.visibility_sharp,
                                        color: AppColors.headline5Color
                                            .withOpacity(.5),
                                      )),
                                ),
                                obscureText: !_controller.obsecure,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => value!.isEmpty
                                    ? 'New password is required'
                                    : null,
                                onSaved: (v) =>
                                    _controller.newPassword = v!.trim(),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  suffixIcon: GestureDetector(
                                    onTap: () => _controller.obsecure2 =
                                        !_controller.obsecure2,
                                    child: Icon(
                                      _controller.obsecure2
                                          ? Icons.visibility_off_sharp
                                          : Icons.visibility_sharp,
                                      color: AppColors.headline5Color
                                          .withOpacity(.5),
                                    ),
                                  ),
                                ),
                                obscureText: !_controller.obsecure2,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => value!.isEmpty
                                    ? 'Confirm Password is required'
                                    : null,
                                onSaved: (v) =>
                                    _controller.confirmPassword = v!.trim(),
                              ),
                            ],
                          )),
                      SizedBox(height: Get.height * 0.03),
                      _controller.loading
                          ? Loading()
                          : MyElevatedButton(
                              buttonText: 'Change',
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                if (_controller.newPassword.trim() !=
                                    _controller.confirmPassword.trim()) {
                                  showSnackBar("Password does not match",
                                      color: Colors.red);
                                  return;
                                }
                                _controller.setForgettPassword(
                                    email, token, _controller.confirmPassword);
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
