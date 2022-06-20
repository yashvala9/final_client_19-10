import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class CreateProfileView extends StatelessWidget {
  CreateProfileView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final _nameController = TextEditingController();
    final _aboutController = TextEditingController();

    return Scaffold(
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: isKeyboardVisible
                          ? Get.height * 0.02
                          : Get.height * 0.08,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Set your Profile',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.headlineSmall?.copyWith(
                                color: AppColors.headline5Color,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              'Please fill following details',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.bodyLarge?.copyWith(
                                color: AppColors.subtitle2Color.withOpacity(.6),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              'Name',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge?.copyWith(
                                color: AppColors.labelLarge,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Container(
                              height: Get.height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.textFieldColor,
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.none,
                                  child: Image.asset(
                                    Assets.cameraImage,
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              'Name',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge?.copyWith(
                                color: AppColors.labelLarge,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.01),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                value!.isEmpty ? 'Name is required' : '';
                              },
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Text(
                              'About',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge?.copyWith(
                                color: AppColors.labelLarge,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.01),
                            TextFormField(
                              controller: _aboutController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText: 'Type Here',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: Get.height * 0.02),
                            MyElevatedButton(
                              buttonText: 'Submit',
                              onPressed: () => Get.toNamed(AppRoutes.home),
                            ),
                          ],
                        ),
                        Positioned(
                          right: Get.width * 0.06,
                          top: Get.height * 0.37,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: Get.width * 0.1,
                              height: Get.width * 0.1,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    blurRadius: 3,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.circular(Get.width * 0.1),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
