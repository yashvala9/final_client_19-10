import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/auth_controller.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    return Scaffold(
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
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value!.isEmpty
                            ? 'Email is required'
                            : !value.isEmail
                                ? "Invalid email"
                                : null,
                      onSaved: (v) => _controller.forgetPasswordEmail = v!,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.03),
                    MyElevatedButton(
                      buttonText: 'Reset Password',
                      onPressed: () {
                        // if(!_formKey.currentState!.validate()){
                        //   return;
                        // }
                        // _formKey.currentState!.save();
                        // _controller.generateForgetPasswordToken("salman@yopmail.com");
                        Get.toNamed(AppRoutes.verifyEmail);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
