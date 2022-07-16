import 'package:get/get.dart';

import '../controllers/my_contest_controller.dart';

class MyContestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyContestController>(
      () => MyContestController(),
    );
  }
}
