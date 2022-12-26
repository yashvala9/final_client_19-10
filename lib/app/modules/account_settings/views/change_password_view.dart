import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/repositories/profile_repository.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/snackbar.dart';
import '../../../../widgets/my_elevated_button.dart';
import '../controllers/account_settings_controller.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({Key? key}) : super(key: key);
  RxBool obsecure1 = false.obs;
  RxBool obsecure2 = false.obs;
  RxBool obsecure3 = false.obs;

  final controller = Get.put(AccountSettingsController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              Obx(
                () => TextFormField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.grey[700],
                        hintText: 'Old Password',
                        suffixIcon: GestureDetector(
                          onTap: () => obsecure1.value = !obsecure1.value,
                          child: Icon(
                            obsecure2.value
                                ? Icons.visibility_sharp
                                : Icons.visibility_off_sharp,
                            color: AppColors.headline5Color.withOpacity(.5),
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.white)),
                    obscureText: !obsecure1.value,
                    onSaved: (v) => controller.password = v!,
                    validator: (value) => value!.isEmpty
                        ? 'Password is required'
                        : value.length < 8
                            ? "Password should be greater than 8 characters"
                            : null),
              ),
              SizedBox(height: Get.height * 0.03),
              Obx(
                () => TextFormField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.grey[700],
                        hintText: 'New Password',
                        suffixIcon: GestureDetector(
                          onTap: () => obsecure2.value = !obsecure2.value,
                          child: Icon(
                            obsecure2.value
                                ? Icons.visibility_sharp
                                : Icons.visibility_off_sharp,
                            color: AppColors.headline5Color.withOpacity(.5),
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.white)),
                    obscureText: !obsecure2.value,
                    onSaved: (v) => controller.newPassword = v!,
                    validator: (value) => value!.isEmpty
                        ? 'Password is required'
                        : value.length < 8
                            ? "Password should be greater than 8 characters"
                            : null),
              ),
              SizedBox(height: Get.height * 0.03),
              Obx(
                () => TextFormField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.grey[700],
                        hintText: 'Confirm Password',
                        suffixIcon: GestureDetector(
                          onTap: () => obsecure3.value = !obsecure3.value,
                          child: Icon(
                            obsecure3.value
                                ? Icons.visibility_sharp
                                : Icons.visibility_off_sharp,
                            color: AppColors.headline5Color.withOpacity(.5),
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.white)),
                    obscureText: !obsecure1.value,
                    onSaved: (v) => controller.password = v!,
                    validator: (value) => value!.isEmpty
                        ? 'Password is required'
                        : value.length < 8
                            ? "Password should be greater than 8 characters"
                            : null),
              ),
              SizedBox(height: Get.height * 0.03),
              MyElevatedButton(
                buttonText: 'Submit',
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  ProfileRepository().changePassword(controller.password,
                      controller.newPassword, controller.token!);
                  Get.back();
                  showSnackBar('Your password has been udpated!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
