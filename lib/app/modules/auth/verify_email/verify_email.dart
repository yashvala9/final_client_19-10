import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/auth/auth_controller.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/utils/constants.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());
  final _storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final _text1 = TextEditingController();
    final _text2 = TextEditingController();
    final _text3 = TextEditingController();
    final _text4 = TextEditingController();
    final _text5 = TextEditingController();

    final node = FocusScope.of(context);

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
                            ? const Loading()
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
                                  // SizedBox(height: Get.height * 0.02),
                                  // Form(
                                  //   key: _formKey,
                                  //   child: Padding(
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: Get.width * 0.08),
                                  //     child: Row(
                                  //       children: [
                                  //         OTPTextField(
                                  //           text: _text1,
                                  //           onChanged: (value) {
                                  //             if (value.trim().length == 1) {
                                  //               node.nextFocus();
                                  //             }
                                  //           },
                                  //         ),
                                  //         SizedBox(width: Get.width * 0.015),
                                  //         OTPTextField(
                                  //           text: _text2,
                                  //           onChanged: (value) {
                                  //             if (value.trim().length == 1) {
                                  //               node.nextFocus();
                                  //             }
                                  //           },
                                  //         ),
                                  //         SizedBox(width: Get.width * 0.015),
                                  //         OTPTextField(
                                  //           text: _text3,
                                  //           onChanged: (value) {
                                  //             if (value.trim().length == 1) {
                                  //               node.nextFocus();
                                  //             }
                                  //           },
                                  //         ),
                                  //         SizedBox(width: Get.width * 0.015),
                                  //         OTPTextField(
                                  //           text: _text4,
                                  //           onChanged: (value) {
                                  //             if (value.trim().length == 1) {
                                  //               node.nextFocus();
                                  //             }
                                  //           },
                                  //         ),
                                  //         SizedBox(width: Get.width * 0.015),
                                  //         OTPTextField(
                                  //           text: _text5,
                                  //           onChanged: (value) {
                                  //             if (value.length == 1) {
                                  //               if (_text1.text.length == 1) {
                                  //                 if (_text2.text.length == 1) {
                                  //                   if (_text3.text.length == 1) {
                                  //                     if (_text4.text.length == 1) {
                                  //                       // String _otp =
                                  //                       // '${_text1.text}${_text2.text}${_text3.text}${_text4.text}';
                                  //                     }
                                  //                   }
                                  //                 }
                                  //               }
                                  //             }
                                  //           },
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

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
                                      ? const Loading()
                                      : MyElevatedButton(
                                          buttonText: 'Send Verification Link',
                                          onPressed: () {
                                            var email =
                                                _storage.read(Constants.email);
                                            _authController.verifyOtp(email);
                                            // => Get.toNamed(AppRoutes.resetPassword)
                                            // final otp =
                                            //     '${_text1.text}${_text2.text}${_text3.text}${_text4.text}${_text5.text}';
                                            // data['otp'] = otp;
                                            // print("Otp: $otp");
                                            // print("verifyOtpData: $data");
                                            // _authController.verifyOtp(data);
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
        // keyboardType: TextInputType.number,
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
