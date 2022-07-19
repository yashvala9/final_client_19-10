import 'package:get/get.dart';

import '../controllers/giveaway_controller.dart';

class GiveawayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GiveawayController>(
      () => GiveawayController(),
    );
  }
}
