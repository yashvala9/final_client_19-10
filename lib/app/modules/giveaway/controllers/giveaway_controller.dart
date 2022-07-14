import 'package:get/get.dart';

class GiveawayController extends GetxController {
  //TODO: Implement EntryCountController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
