import 'package:get/get.dart';

import '../controllers/contest_dates_controller.dart';

class ContestDatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestDatesController>(
      () => ContestDatesController(),
    );
  }
}
