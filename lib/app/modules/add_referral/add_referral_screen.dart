import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/my_elevated_button.dart';
import '../auth/auth_controller.dart';

class AddReferralScreen extends StatelessWidget {
  AddReferralScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(AuthController());
  final _authService = Get.find<AuthService>();

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
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
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
                                  Assets.addReferral,
                                  width: Get.width * 0.5,
                                  height: Get.width * 0.5,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Enter your referal code',
                            textScaleFactor: Get.textScaleFactor,
                            style: style.headlineSmall,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            'Please enter your referal code below',
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
                                  hintText: 'Enter your code',
                                ),
                                validator: (value) => value!.isEmpty
                                    ? 'Code is required to submit'
                                    : null,
                                onSaved: (v) =>
                                    _controller.referrerId = v!.trim(),
                              )),
                          SizedBox(height: Get.height * 0.03),
                          _controller.loading
                              ? Loading()
                              : MyElevatedButton(
                                  buttonText: 'Submit',
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    _formKey.currentState!.save();
                                    _controller.addReferral(
                                        _controller.referrerId,
                                        _authService.profileModel!.id
                                            .toString(),
                                        _authService.token!);
                                  },
                                ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 12,
                      child: TextButton(
                        onPressed: () {
                          _controller.setReferralStatus(
                              _authService.profileModel!.id.toString(),
                              _authService.token!);
                        },
                        child: const Text("SKIP"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
