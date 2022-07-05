import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }
}
