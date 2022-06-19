import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final _text1 = TextEditingController();
    final _text2 = TextEditingController();
    final _text3 = TextEditingController();
    final _text4 = TextEditingController();

    final node = FocusScope.of(context);

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
                      child: Image.asset(Assets.emailImage),
                    ),
                    Text(
                      'Verify your email',
                      style: style.headlineSmall?.copyWith(
                        color: AppColors.headline5Color,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      'Please check your email to take 4 digit\ncode for continue.',
                      style: style.bodyLarge?.copyWith(
                        color: AppColors.subtitle2Color.withOpacity(.6),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                        child: Row(
                          children: [
                            OTPTextField(
                              text: _text1,
                              onChanged: (value) {
                                if (value.trim().length == 1) {
                                  node.nextFocus();
                                }
                              },
                            ),
                            OTPTextField(
                              text: _text2,
                              onChanged: (value) {
                                if (value.trim().length == 1) {
                                  node.nextFocus();
                                }
                              },
                            ),
                            OTPTextField(
                              text: _text3,
                              onChanged: (value) {
                                if (value.trim().length == 1) {
                                  node.nextFocus();
                                }
                              },
                            ),
                            OTPTextField(
                              text: _text4,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  if (_text1.text.length == 1) {
                                    if (_text2.text.length == 1) {
                                      if (_text3.text.length == 1) {
                                        if (_text4.text.length == 1) {
                                          String _otp =
                                              '${_text1.text}${_text2.text}${_text3.text}${_text4.text}';
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.03),
                    MyElevatedButton(
                      buttonText: 'Submit',
                      onPressed: () {
                        Get.toNamed(AppRoutes.resetPassword);
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
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.subtitle1Color.withOpacity(.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.subtitle1Color.withOpacity(.8)),
          ),
        ),
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
      ),
    );
  }
}
