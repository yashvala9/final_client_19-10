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

class HelpView extends StatelessWidget {
  HelpView({Key? key}) : super(key: key);

  final controller = Get.put(AccountSettingsController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: const Text(
          "Help",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            const Text(
              'Write an email to our team at ReelRo, we will do our best to resolve your query. Thank you!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: Get.height * 0.01),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your email...',
              ),
              keyboardType: TextInputType.multiline,
              validator: (v) => v!.isEmpty ? "Message cannot be empty!" : null,
              onFieldSubmitted: (value) => controller.message = value,
            ),
            SizedBox(height: Get.height * 0.03),
            MyElevatedButton(
              buttonText: 'Submit',
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                ProfileRepository()
                    .reportBug(controller.message, controller.token!);
                Get.back();
                showSnackBar(
                    'Your response has been sent to \'help@reelro.com\'');
              },
            ),
          ]),
        ),
      ),
    );
  }
}
