import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final _emailController = TextEditingController();

    return Scaffold(
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.1,
                  vertical: Get.height * 0.15,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.4,
                      width: Get.width,
                      child: Image.asset(Assets.lockImage),
                    ),
                    Text(
                      'Forgot password?',
                      style: style.headlineSmall?.copyWith(
                        color: AppColors.headline5Color,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      'Enter your email address for recovery\nyour account.',
                      style: style.bodyLarge?.copyWith(
                        color: AppColors.subtitle2Color.withOpacity(.6),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isEmpty ? 'Email is required' : '',
                      ),
                    ),
                    SizedBox(height: Get.height * 0.03),
                    MyElevatedButton(
                      buttonText: 'Reset Password',
                      onPressed: () {},
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
