import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import '../../account_settings/views/account_settings_view.dart';
import '../controllers/giveaway_campaign_controller.dart';

class GiveawayCampaignView extends GetView<GiveawayCampaignController> {
  const GiveawayCampaignView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          onPressed: () {
            Get.to(const AccountSettingsView());
          },
          icon: Image.asset(
            "assets/Left Arrow Icon.png",
            height: 18,
            width: 10.21,
          ),
        ),
        title: const Text(
          "Giveaway",
          style: TextStyle(
            color: Color.fromRGBO(22, 23, 34, 1),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 12),
                child: Text(
                  "Start new giveaway",
                  style: TextStyle(
                    color: Color.fromRGBO(22, 22, 22, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "Upload Prize Image",
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Container(
                color: const Color.fromRGBO(240, 242, 246, 1),
                alignment: Alignment.center,
                child: Image.asset("assets/Gallery Icon.png"),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "Campaign Name",
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
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
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                child: Text(
                  "Prize",
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
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
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "Campaign end date",
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
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
                buttonText: "Start Compaign",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
