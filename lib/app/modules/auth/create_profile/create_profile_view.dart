import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/auth/create_profile/create_profile_controller.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class CreateProfileView extends StatelessWidget {
  CreateProfileView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(CreateProfileController());
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return GetBuilder<CreateProfileController>(
      init: CreateProfileController(),
      builder: (_) => Scaffold(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Set your Profile',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.headlineSmall),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            'Please fill following details',
                            textScaleFactor: Get.textScaleFactor,
                            style: style.bodyLarge,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('Add Profile Picture',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final val = await showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              onTap: () =>
                                                  Navigator.pop(context, true),
                                              leading: const Icon(Icons.camera),
                                              title: const Text("Camera"),
                                            ),
                                            ListTile(
                                              onTap: () =>
                                                  Navigator.pop(context, false),
                                              leading: const Icon(Icons.photo),
                                              title: const Text("Gallery"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                  if (val != null) {
                                    var imageSource = val
                                        ? ImageSource.camera
                                        : ImageSource.gallery;
                                    try {
                                      XFile? file = await _picker.pickImage(
                                        source: imageSource,
                                      );
                                      if (file != null) {
                                        File? croppedFile =
                                            await ImageCropper().cropImage(
                                          sourcePath: file.path,
                                          aspectRatioPresets: [
                                            CropAspectRatioPreset.original,
                                            CropAspectRatioPreset.square,
                                            CropAspectRatioPreset.ratio4x3,
                                            CropAspectRatioPreset.ratio16x9
                                          ],
                                          /*   androidUiSettings:
                                              const AndroidUiSettings(
                                            activeControlsWidgetColor:
                                                Utils.brandColor,
                                            statusBarColor: Colors.transparent,
                                          ), */
                                        );
                                        if (croppedFile != null) {
                                          _controller.file = croppedFile;
                                          // Navigator.pop(context);
                                        }
                                      }
                                    } catch (e) {
                                      print("selectSourcePage Gallery: $e");
                                    }
                                  }
                                },
                                child: Container(
                                  height: Get.height * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.textFieldColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: _controller.file != null
                                      ? Image.file(
                                          _controller.file!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          Assets.cameraImage,
                                          width: Get.width * 0.1,
                                          height: Get.width * 0.1,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
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
                                      borderRadius: BorderRadius.circular(
                                          Get.width * 0.1),
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
                          SizedBox(height: Get.height * 0.02),
                          Text('Full Name',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          TextFormField(
                            enabled: !_controller.loading,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                value!.isEmpty ? 'Name is required' : null,
                            onSaved: (v) => _controller.fullName = v!,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            'Add About Me',
                            textScaleFactor: Get.textScaleFactor,
                            style: style.labelLarge?.copyWith(
                              color: AppColors.labelLarge,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.01),
                          TextFormField(
                            enabled: !_controller.loading,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Type Here',
                            ),
                            keyboardType: TextInputType.text,
                            validator: (v) =>
                                v!.isEmpty ? "About is required" : null,
                          ),
                          SizedBox(height: Get.height * 0.03),
                          _controller.loading
                              ? const Loading()
                              : MyElevatedButton(
                                  buttonText: 'Submit',
                                  onPressed: () {
                                    // if (!_formKey.currentState!.validate()) {
                                    //   return;
                                    // }
                                    // if (_controller.file == null) {
                                    //   return;
                                    // }
                                    // _formKey.currentState!.save();
                                    // _controller.addProfileData();
                                    Get.toNamed(AppRoutes.home);
                                  },
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
      ),
    );
  }
}
