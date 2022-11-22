import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/utils/colors.dart';

import '../controllers/contest_rules_controller.dart';

class ContestRulesView extends GetView<ContestRulesController> {
  const ContestRulesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    Get.put(ContestRulesController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        backgroundColor: Color.fromARGB(255, 255, 229, 84),
        title: const Text(
          'Contest Rules',
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
        elevation: 2,
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.contestrulesbrown,
              AppColors.contestrulesligthbrown,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Common Rules for all the contests:',
              style: style.titleLarge!.copyWith(
                color: AppColors.winnercardbrown,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
                '\n1. Rule no 1,\n2. Rule no 2,\n3. Rule no 3,\n4. Rule no 4\n5. Rule no 5\n6. Rule no 6'),
          ],
        ),
      ),
    );
  }
}
