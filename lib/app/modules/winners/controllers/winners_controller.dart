import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';

import '../../../../services/auth_service.dart';

class WinnersController extends GetxController {
  final _authService = Get.put(AuthService());
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;
  final RxList<WinnerList> winnerList = RxList<WinnerList>();
  final RxBool isLoading = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    _fetch();
    super.onInit();
  }

  _fetch() async {}

  Future<void> getWinnerList() async {
    winnerList.clear();
    isLoading(true);
    await Future.delayed(1000.milliseconds, () async {
      winnerList.addAll(DemoData.demoWinnerList);
    });
    isLoading(false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
