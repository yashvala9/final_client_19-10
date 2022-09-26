import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/controllers/chat_list_controller.dart';

class ChatListBinding implements Bindings  {
  @override
  void dependencies() {
    Get.lazyPut<ChatListController>(() => ChatListController());
  }

}