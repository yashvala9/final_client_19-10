import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../services/communication_services.dart';
import '../chat_state/chat_state.dart';

class ChatController extends GetxController with StateMixin<ChatState> {
  final Channel channel;
  ChatController({required this.channel});
  final CommunicationService _communicationService = CommunicationService.to;

  final ScrollController scrollController = ScrollController();

  @override
  ChatState get state => ChatState.initial(channel);

  @override
  void onInit() {
    change(state);
    log(channel.toString());
    _init();
    super.onInit();
  }

  void _init() async {
    try {
      await value!.currentChannel.watch();

      change(
        value!.copyWith(currentChannel: value!.currentChannel),
        status: RxStatus.success(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
