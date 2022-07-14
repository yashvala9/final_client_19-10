import 'package:get/get.dart';

import '../controllers/entry_count_controller.dart';

class EntryCountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryCountController>(
      () => EntryCountController(),
    );
  }
}
