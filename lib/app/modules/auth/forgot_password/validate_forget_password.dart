import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/auth_controller.dart';
import 'package:reel_ro/widgets/loading.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/my_elevated_button.dart';

class ValidateForgetPassword extends StatelessWidget {
  final String email;
  ValidateForgetPassword({Key? key, required this.email}) : super(key: key);

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
                        'Enter Token',
                        textScaleFactor: Get.textScaleFactor,
                        style: style.headlineSmall,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        'Please enter the token that has been shared with your respected email address.',
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
                            hintText: 'Enter token',
                          ),
                          maxLength: 7,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'))
                          ],
                          validator: (value) => value!.isEmpty
                              ? 'Token is required'
                              : value.length != 7
                                  ? "Token must be 7 character"
                                  : null,
                          onSaved: (v) => _controller.forgetPassworedToken =
                              v!.trim().toUpperCase(),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.03),
                      _controller.loading
                          ? const Loading()
                          : MyElevatedButton(
                              buttonText: 'Submit',
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                _controller.validateForgetPassword(
                                    email, _controller.forgetPassworedToken);
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
