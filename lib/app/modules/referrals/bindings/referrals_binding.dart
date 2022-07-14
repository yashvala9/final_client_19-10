import 'package:get/get.dart';

import '../controllers/referrals_controller.dart';

class ReferralsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralsController>(
      () => ReferralsController(),
    );
  }
}
