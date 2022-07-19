import 'package:get/get.dart';

import '../controllers/contest_rules_controller.dart';

class ContestRulesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestRulesController>(
      () => ContestRulesController(),
    );
  }
}
