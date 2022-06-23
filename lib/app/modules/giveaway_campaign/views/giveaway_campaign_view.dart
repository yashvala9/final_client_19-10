import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import '../../account_settings/views/account_settings_view.dart';
import '../controllers/giveaway_campaign_controller.dart';

class GiveawayCampaignView extends GetView<GiveawayCampaignController> {
  const GiveawayCampaignView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          "Giveaway",
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
                padding: const EdgeInsets.only(top: 20, left: 12),
                child: Text(
                  "Start new giveaway",
                  style: style.titleMedium,
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
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
              Container(
                color: const Color.fromRGBO(240, 242, 246, 1),
                alignment: Alignment.center,
                child: const Icon(Icons.photo_outlined),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  "Campaign Name",
                  style: style
                      .titleMedium, 
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Input",
                ),
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
                  style: style
                      .titleMedium, 
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Input",
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  "Campaign end date",
                  style: style
                      .titleMedium, 
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Input",
                    hintText: "Input",
                    filled: true,
                    fillColor: Color.fromRGBO(240, 242, 246, 1),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              MyElevatedButton(
                buttonText: "Start Campaign",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
