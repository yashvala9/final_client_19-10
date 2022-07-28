import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/auth_controller.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/loading.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/my_elevated_button.dart';
import '../../../routes/app_routes.dart';

class SetForgetPassword extends StatelessWidget {
  final String email;
  final String token;
  SetForgetPassword({Key? key, required this.email, required this.token})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                        'Forgot password?',
                        textScaleFactor: Get.textScaleFactor,
                        style: style.headlineSmall,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        'Enter your email address for recovery\nyour account.',
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
                                decoration: const InputDecoration(
                                  hintText: 'New Password',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => value!.isEmpty
                                    ? 'New password is required'
                                    : null,
                                onSaved: (v) =>
                                    _controller.newPassword = v!.trim(),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Confirm Password',
                                ),
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
                          ? const Loading()
                          : MyElevatedButton(
                              buttonText: 'Reset Password',
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
