import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';

class WinnersController extends GetxController {
  final RxList<WinnerList> winnerList = RxList<WinnerList>();
  final RxBool isLoading = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    _fetch();
    super.onInit();
  }

  _fetch() async {
    await getWinnerList();
  }

  Future<void> getWinnerList() async {
    winnerList.clear();
    isLoading(true);
    await Future.delayed(1000.milliseconds, () async {
      for (var element in DemoData.demoWinnerList) {
        winnerList.add(element);
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
