import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reel_ro/app/modules/my_contest/views/my_contest_view.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import '../../../../repositories/giveaway_repository.dart';
import '../../../../widgets/loading.dart';
import '../../account_settings/views/account_settings_view.dart';
import '../../add_feed/add_feed_screen.dart';
import '../controllers/giveaway_campaign_controller.dart';

class GiveawayCampaignView extends GetView<GiveawayCampaignController> {
  GiveawayCampaignView({Key? key}) : super(key: key);
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(GiveawayCampaignController());
  TextEditingController dateInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          " Create Giveaway",
          style: style.titleMedium,
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
              GestureDetector(
                onTap: () async {
                  var photo = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    _controller.photo = File(photo.path);
                    _controller.uploadImage();
                  }
                },
                child: Container(
                  height: 150,
                  color: const Color.fromRGBO(240, 242, 246, 1),
                  alignment: Alignment.center,
                  child: Obx(
                    () => _controller.photoLoading.value
                        ? const Loading()
                        : _controller.photoUrl.value == ''
                            ? const Icon(Icons.photo_outlined)
                            : Image(
                                image:
                                    NetworkImage(_controller.photoUrl.value)),
                  ),
                ),
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
                  hintText: 'July Campaign',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
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
                  "Prize",
                  style: style.titleMedium,
                ),
              ),
              TextFormField(
                enabled: !_controller.loading,
                decoration: const InputDecoration(
                  hintText: 'Tata Altroz',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
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
                    labelText: "End Date" //label text of field
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
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
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
    );
  }
}
