import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';

class ContestRulesController extends GetxController {
  final RxList<ContestRules> contestRulesList = RxList<ContestRules>();
  final RxBool isLoading = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    _fetch();
    super.onInit();
  }

  _fetch() async {
    await getContestDates();
  }

  Future<void> getContestDates() async {
    contestRulesList.clear();
    isLoading(true);
    await Future.delayed(1000.milliseconds, () async {
      contestRulesList.addAll(DemoData.demoContestRules);
    });
    isLoading(false);
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
