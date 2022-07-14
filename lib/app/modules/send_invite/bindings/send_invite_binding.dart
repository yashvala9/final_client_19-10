import 'package:get/get.dart';

import '../controllers/send_invite_controller.dart';

class SendInviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendInviteController>(
      () => SendInviteController(),
    );
  }
}
