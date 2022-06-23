import 'package:get/get.dart';
import '../controllers/follower_picker_controller.dart';

class FollowerPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowerPickerController>(
          () => FollowerPickerController(),
    );
  }
}