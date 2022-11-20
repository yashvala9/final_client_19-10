import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/auth/auth_controller.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/utils/constants.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({Key? key}) : super(key: key);

  final _authController = Get.put(AuthController());
  final _storage = GetStorage();
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
                        child: _authController.loading
                            ? Loading()
                            : Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.4,
                                    width: Get.width,
                                    child: Center(
                                        child: FittedBox(
                                      fit: BoxFit.none,
                                      child: Image.asset(
                                        Assets.emailImage,
                                        width: Get.width * 0.5,
                                        height: Get.width * 0.5,
                                      ),
                                    )),
                                  ),
                                  SizedBox(height: Get.height * 0.02),
                                  Text(
                                    'Verify your email',
                                    textScaleFactor: Get.textScaleFactor,
                                    style: style.headlineSmall?.copyWith(
                                      color: AppColors.headline5Color,
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.02),
                                  Text(
                                    'Email verification link has been send to your register mail\n please click the given link to verify the email',
                                    textScaleFactor: Get.textScaleFactor,
                                    textAlign: TextAlign.center,
                                    style: style.bodyLarge?.copyWith(
                                      color: AppColors.subtitle2Color
                                          .withOpacity(.6),
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.03),
                                  TextButton(
                                    onPressed: () {
                                      var email =
                                          _storage.read(Constants.email);
                                      var password =
                                          _storage.read(Constants.password);
                                      _authController.refereshVerifyEmail(
                                          email, password);
                                    },
                                    child: const Text("Refresh"),
                                  ),
                                  SizedBox(height: Get.height * 0.03),
                                  _authController.loading
                                      ? Loading()
                                      : MyElevatedButton(
                                          buttonText: 'Send Verification Link',
                                          onPressed: () {
                                            var email =
                                                _storage.read(Constants.email);
                                            _authController.verifyOtp(email);
                                          },
                                        ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class OTPTextField extends StatelessWidget {
  const OTPTextField({
    Key? key,
    this.text,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController? text;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: text,
        maxLength: 1,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.subtitle1Color.withOpacity(.1)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.subtitle1Color.withOpacity(.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.subtitle1Color.withOpacity(.6)),
          ),
        ),
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
      ),
    );
  }
}
