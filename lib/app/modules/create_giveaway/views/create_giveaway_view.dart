import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reel_ro/app/modules/my_contest/views/my_contest_view.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import '../../../../repositories/giveaway_repository.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/loading.dart';
import '../../account_settings/views/account_settings_view.dart';
import '../../add_feed/add_feed_screen.dart';
import '../controllers/create_giveaway_controller.dart';

class CreateGiveawayView extends GetView<CreateGiveawayController> {
  CreateGiveawayView({Key? key}) : super(key: key);
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(CreateGiveawayController());
  TextEditingController dateInput = TextEditingController();
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return GetBuilder<CreateGiveawayController>(
      init: CreateGiveawayController(),
      builder: (_) => Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          title: Text(
            "Create Giveaway",
            style: style.titleMedium,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Upload Prize Image",
                    style: style.titleMedium,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
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
                                    onTap: () => Navigator.pop(context, true),
                                    leading: const Icon(Icons.camera),
                                    title: const Text("Camera"),
                                  ),
                                  ListTile(
                                    onTap: () => Navigator.pop(context, false),
                                    leading: const Icon(Icons.photo),
                                    title: const Text("Gallery"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        if (val != null) {
                          var imageSource =
                              val ? ImageSource.camera : ImageSource.gallery;
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
                                // _controller.updateFile(croppedFile);
                                _controller.file = croppedFile;
                                debugPrint('ola ola');
                              }
                              _controller.update();
                            }
                          } catch (e) {
                            debugPrint("selectSourcePage Gallery: $e");
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
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    "Campaign Name",
                    style: style.titleMedium,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                TextFormField(
                  enabled: !_controller.loading,
                  decoration: const InputDecoration(
                    hintText: 'Please enter Campaign Name',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9, ]')),
                  ],
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return value!.isEmpty ? 'Campaign Name is required' : null;
                  },
                  onChanged: (v) => _controller.campaignName = v,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text(
                    "Prize name",
                    style: style.titleMedium,
                  ),
                ),
                TextFormField(
                  enabled: !_controller.loading,
                  decoration: const InputDecoration(
                    hintText: 'Tata Altroz',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9, ]')),
                  ],
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return value!.isEmpty ? 'Prize Name is required' : null;
                  },
                  onChanged: (v) => _controller.prizeName = v,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    "Campaign end date",
                    style: style.titleMedium,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                TextField(
                  controller: dateInput,
                  //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      hintText: "End Date" //label text of field
                      ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        // - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      debugPrint(pickedDate
                          .toString()); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      debugPrint(
                          formattedDate); //formatted date output using intl package =>  2021-03-16

                      _controller.endDate = DateTime.parse(formattedDate);

                      dateInput.text =
                          formattedDate; //set output date to TextField value.

                    } else {}
                  },
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                MyElevatedButton(
                  buttonText: "Start Campaign",
                  onPressed: () async {
                    await _controller.createGiveaway();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
