import 'package:get/get.dart';

import '../../../../services/auth_service.dart';

class SendInviteController extends GetxController {
  final _authService = Get.put(AuthService());
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
}
