import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reel_ro/app/modules/navigation_bar/navigation_bar_screen.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/utils/assets.dart';
import '../../../../utils/base.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/snackbar.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/my_elevated_button.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({Key? key, required this.profileEditCalBack})
      : super(key: key);
  final VoidCallback profileEditCalBack;

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(EditProfileController());
  final _picker = ImagePicker();
  var parser = EmojiParser();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
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
                          Text('Edit your Profile',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.headlineSmall),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            'Please fill following details',
                            textScaleFactor: Get.textScaleFactor,
                            style: style.bodyLarge,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('Profile Picture',
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
                                      : _controller.profileModel.user_profile!
                                                  .profile_img !=
                                              ''
                                          ? Image.network(
                                              "${Base.profileBucketUrl}/${_controller.profileModel.user_profile!.profile_img}")
                                          : Image.asset(
                                              Assets.cameraImage,
                                              width: Get.width * 0.1,
                                              height: Get.width * 0.1,
                                            ),
                                ),
                              ),
                              // Positioned(
                              //   bottom: 0,
                              //   child: GestureDetector(
                              //     onTap: () {},
                              //     child: Container(
                              //       width: Get.width * 0.1,
                              //       height: Get.width * 0.1,
                              //       decoration: BoxDecoration(
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: Colors.black.withOpacity(.1),
                              //             offset: const Offset(0, 5),
                              //             blurRadius: 3,
                              //           ),
                              //         ],
                              //         borderRadius: BorderRadius.circular(
                              //             Get.width * 0.1),
                              //         color: Colors.white,
                              //       ),
                              //       child: const Icon(
                              //         Icons.add,
                              //         color: AppColors.yellowOrange,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('Username',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          TextFormField(
                            enabled: false,
                            //  !_controller.loading,
                            decoration: InputDecoration(
                              hintText: _controller.profileModel.username,
                              prefixIcon: Icon(
                                CupertinoIcons.person_solid,
                                color: AppColors.headline5Color.withOpacity(.5),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z0-9]')),
                            ],
                            keyboardType: TextInputType.name,
                            // validator: (value) {
                            //   return value!.isEmpty
                            //       ? 'Username is required'
                            //       : value.length > 12
                            //           ? "Username cannot be greater than 12 characters"
                            //           : null;
                            // },
                            onChanged: (v) => _controller.username = v,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('Full Name',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          TextFormField(
                            enabled: !_controller.loading,
                            decoration: InputDecoration(
                              hintText: _controller
                                  .profileModel.user_profile!.fullname,
                            ),
                            keyboardType: TextInputType.name,
                            // validator: (value) =>
                            //     value!.isEmpty ? 'Name is required' : null,
                            onChanged: (v) => _controller.fullname = v,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('Mobile Number',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                    enabled: !_controller.loading,
                                    decoration: InputDecoration(
                                      hintText: _controller
                                          .profileModel.user_profile!.phone_pin,
                                      counterText: '',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9,+]')),
                                    ],
                                    maxLength: 3,
                                    validator: (v) =>
                                        v!.isNotEmpty && v.length != 2
                                            ? "Country code must be 2 digits"
                                            : null,
                                    onChanged: (v) =>
                                        _controller.phone_pin = int.parse(v)),
                              ),
                              SizedBox(
                                width: Get.width * 0.03,
                              ),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  enabled: !_controller.loading,
                                  decoration: InputDecoration(
                                    hintText: _controller.profileModel
                                        .user_profile!.phone_number,
                                    prefixIcon: Icon(
                                      Icons.phone_android_sharp,
                                      color: AppColors.headline5Color
                                          .withOpacity(.5),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  // maxLength: 10,
                                  validator: (value) {
                                    return value!.isNotEmpty &&
                                            value.length != 10
                                        ? "Mobile number must be 10 digits"
                                        : null;
                                  },
                                  onChanged: (v) =>
                                      _controller.phone_number = int.parse(v),
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
                            decoration: InputDecoration(
                              hintText: _controller
                                  .profileModel.user_profile!.country,
                            ),
                            keyboardType: TextInputType.name,
                            // validator: (value) =>
                            //     value!.isEmpty ? 'Name is required' : null,
                            onChanged: (v) => _controller.country = v,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text('State',
                              textScaleFactor: Get.textScaleFactor,
                              style: style.labelLarge),
                          SizedBox(height: Get.height * 0.01),
                          TextFormField(
                            enabled: !_controller.loading,
                            decoration: InputDecoration(
                              hintText:
                                  _controller.profileModel.user_profile!.state,
                            ),
                            keyboardType: TextInputType.name,
                            // validator: (value) =>
                            //     value!.isEmpty ? 'Name is required' : null,
                            onChanged: (v) => _controller.state = v,
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
                            decoration: InputDecoration(
                              hintText: parser.emojify(
                                  _controller.profileModel.user_profile!.bio!),
                            ),
                            initialValue: parser.emojify(
                                _controller.profileModel.user_profile!.bio!),
                            keyboardType: TextInputType.multiline,
                            // validator: (v) =>
                            //     v!.isEmpty ? "About is required" : null,
                            onChanged: (v) =>
                                _controller.bio = parser.unemojify(v),
                          ),
                          SizedBox(height: Get.height * 0.03),
                          _controller.loading
                              ? const Loading()
                              : MyElevatedButton(
                                  buttonText: 'Submit',
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    await _controller.updateProfile();
                                    profileEditCalBack();
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
    // Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     leading: IconButton(
    //         icon: const Icon(Icons.arrow_back_ios),
    //         onPressed: () {
    //           Get.back();
    //         }),
    //     title: const Center(child: Text("Edit Profille")),
    //   ),
    //   backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    //   body: Column(
    //     children: [
    //       SizedBox(
    //         height: Get.height * 0.03,
    //       ),
    //       const Center(
    //         child: CircleAvatar(
    //           backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
    //           backgroundImage: AssetImage(Assets.profile),
    //           radius: 45,
    //         ),
    //       ),
    //       SizedBox(
    //         height: Get.height * 0.01,
    //       ),
    //       Text(
    //         "Change photo",
    //         style: style.titleMedium,
    //       ),
    //       SizedBox(
    //         height: Get.height * 0.06,
    //       ),
    //       Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             child: Text(
    //               "Name",
    //               style: style.titleMedium,
    //             ),
    //           ),
    //           const Spacer(),
    //           Text(
    //             profileModel.user_profile!.fullname!,
    //             style: style.titleMedium,
    //           ),
    //           IconButton(
    //             onPressed: () {},
    //             icon: Image.asset(
    //               "assets/Right Arrow Icon.png",
    //               height: 10.5,
    //               width: 5.79,
    //             ),
    //           ),
    //         ],
    //       ),
    //       Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             child: Text(
    //               "Username",
    //               style: style.titleMedium,
    //             ),
    //           ),
    //           const Spacer(),
    //           Text(
    //             profileModel.username!,
    //             style: style.titleMedium,
    //           ),
    //           IconButton(
    //             onPressed: () {},
    //             icon: Image.asset(
    //               "assets/Right Arrow Icon.png",
    //               height: 10.5,
    //               width: 5.79,
    //             ),
    //           ),
    //         ],
    //       ),
    //       Row(
    //         children: [
    //           const Spacer(),
    //           Text(
    //             "reelro.com@" + profileModel.username!,
    //             style: style.titleMedium,
    //           ),
    //           IconButton(
    //             onPressed: () {},
    //             icon: Image.asset(
    //               "assets/Clipboard Stroke Icon.png",
    //               height: 13,
    //               width: 12.5,
    //             ),
    //           ),
    //         ],
    //       ),
    //       Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             child: Text(
    //               "Bio",
    //               style: style.titleMedium,
    //             ),
    //           ),
    //           const Spacer(),
    //           Text(
    //             profileModel.user_profile!.bio!,
    //             style: style.titleMedium,
    //           ),
    //           IconButton(
    //             onPressed: () {},
    //             icon: Image.asset(
    //               "assets/Right Arrow Icon.png",
    //               height: 10.5,
    //               width: 5.79,
    //             ),
    //           ),
    //         ],
    //       ),
    //       const Divider(
    //         color: Color.fromRGBO(208, 209, 211, 1),
    //         thickness: 0.33,
    //       ),
    //       Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             child: Text(
    //               "Email",
    //               style: style.titleMedium,
    //             ),
    //           ),
    //           const Spacer(),
    //           Text(
    //             profileModel.email!,
    //             style: style.titleMedium,
    //           ),
    //           IconButton(
    //             onPressed: () {},
    //             icon: Image.asset(
    //               "assets/Right Arrow Icon.png",
    //               height: 10.5,
    //               width: 5.79,
    //             ),
    //           ),
    //         ],
    //       ),
    //       Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             child: Text(
    //               "Phone",
    //               style: style.titleMedium,
    //             ),
    //           ),
    //           const Spacer(),
    //           Text(
    //             profileModel.user_profile!.phone_number.toString(),
    //             style: style.titleMedium,
    //           ),
    //           IconButton(
    //             onPressed: () {},
    //             icon: Image.asset(
    //               "assets/Right Arrow Icon.png",
    //               height: 10.5,
    //               width: 5.79,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
