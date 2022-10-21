import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';

import '../../../../services/auth_service.dart';

class ContestDatesController extends GetxController {
  final _authService = Get.put(AuthService());
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  final RxList<ContestDates> contestDatesList = RxList<ContestDates>();
  final RxBool isLoading = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    _fetch();
    super.onInit();
  }

  _fetch() async {}

  Future<void> getContestDates() async {
    contestDatesList.clear();
    isLoading(true);
    await Future.delayed(1000.milliseconds, () async {
      contestDatesList.addAll(DemoData.demoContestDatesList);
    });
    isLoading(false);
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
