import 'package:get/get.dart';
import '../controllers/create_giveaway_controller.dart';

class CreateGiveawayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateGiveawayController>(
      () => CreateGiveawayController(),
    );
  }
}
