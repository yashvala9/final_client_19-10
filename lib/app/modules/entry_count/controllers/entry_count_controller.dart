import 'package:get/get.dart';

import '../../../../services/auth_service.dart';

class EntryCountController extends GetxController {
  final _authService = AuthService();
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
}
