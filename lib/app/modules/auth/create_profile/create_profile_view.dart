import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/auth/create_profile/create_profile_controller.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

class CreateProfileView extends StatelessWidget {
  CreateProfileView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(CreateProfileController());
  final _picker = ImagePicker();
  final parser = EmojiParser();

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return GetBuilder<CreateProfileController>(
      init: CreateProfileController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _controller.signOut();
              },
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
              )),
          title: Text(
            "Set Your Profile",
            textScaleFactor: Get.textScaleFactor,
            style: style.headlineSmall,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
                            : Get.height * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        );
                                        if (croppedFile != null) {
                                          _controller.file = croppedFile;
                                        }
                                      }
                                    } catch (e) {
                                      showSnackBar(e.toString(),
                                          color: Colors.red);
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
                            onSaved: (v) => _controller.fullname = v!,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('Mobile Number',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                    enabled: !_controller.loading,
                                    decoration: const InputDecoration(
                                      hintText: '44',
                                      counterText: '',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9,+]')),
                                    ],
                                    maxLength: 3,
                                    validator: (v) => v!.isEmpty
                                        ? "Country code is required"
                                        : v.length != 2
                                            ? "Country code must be 2 digits"
                                            : null,
                                    onSaved: (v) => _controller.countryCode =
                                        int.parse(v!)),
                              ),
                              SizedBox(
                                width: Get.width * 0.03,
                              ),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  enabled: !_controller.loading,
                                  decoration: InputDecoration(
                                    hintText: '9876543210',
                                    prefixIcon: Icon(
                                      Icons.phone_android_sharp,
                                      color: AppColors.headline5Color
                                          .withOpacity(.5),
                                    ),
                                  ),
                                  maxLength: 10,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? 'Mobile number is required'
                                        : value.length != 10
                                            ? "Mobile number must be 10 digits"
                                            : null;
                                  },
                                  onSaved: (v) =>
                                      _controller.mobileNumber = int.parse(v!),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('Country',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          TextFormField(
                            enabled: !_controller.loading,
                            decoration: const InputDecoration(
                              hintText: 'India',
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                value!.isEmpty ? 'Country is required' : null,
                            onSaved: (v) => _controller.country = v!,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('State',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          TextFormField(
                            enabled: !_controller.loading,
                            decoration: const InputDecoration(
                              hintText: 'Gujarat',
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                value!.isEmpty ? 'State is required' : null,
                            onSaved: (v) => _controller.state = v!,
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
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Type Here',
                            ),
                            keyboardType: TextInputType.multiline,
                            validator: (v) =>
                                v!.isEmpty ? "About is required" : null,
                            onSaved: (v) =>
                                _controller.bio = parser.unemojify(v!),
                          ),
                          SizedBox(height: Get.height * 0.03),
                          _controller.loading
                              ? Loading()
                              : MyElevatedButton(
                                  buttonText: 'Submit',
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    if (_controller.file == null) {
                                      showSnackBar("Please select image",
                                          color: Colors.red);
                                      return;
                                    }
                                    _formKey.currentState!.save();
                                    _controller.addProfileData();
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
