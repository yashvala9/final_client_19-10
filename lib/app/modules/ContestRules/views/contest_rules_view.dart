import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/utils/colors.dart';

import '../controllers/contest_rules_controller.dart';

class ContestRulesView extends GetView<ContestRulesController> {
  const ContestRulesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    Get.put(ContestRulesController());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contest Rules',
            style: TextStyle(fontSize: 14),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              )),
        ),
        body: Obx(
          () => !controller.isLoading.value
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.contestRulesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
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
                            controller.contestRulesList[index].title.toString(),
                            style: style.titleLarge!.copyWith(
                              color: AppColors.winnercardbrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller
                                .contestRulesList[index].rules!.length,
                            itemBuilder: (BuildContext context, int index1) {
                              return Text(controller
                                  .contestRulesList[index].rules!
                                  .cast()
                                  .values
                                  .elementAt(index1)
                                  .toString());
                            },
                          )
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                    backgroundColor: Colors.red,
                  ),
                ),
        ));
  }
}
