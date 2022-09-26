import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/controllers/chat_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatBinding extends Bindings {
  final Channel channel;
  ChatBinding({required this.channel});

  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController(channel: channel));
  }
}
