import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';

class ContestDatesController extends GetxController {
  final RxList<ContestDates> contestDatesList = RxList<ContestDates>();
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
    contestDatesList.clear();
    isLoading(true);
    await Future.delayed(1000.milliseconds, () async {
      for (var element in DemoData.demoContestDatesList) {
        contestDatesList.add(element);
      }
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
