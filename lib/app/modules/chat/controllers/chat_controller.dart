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
    // QueryUsersResponse _streamUserData = await CommunicationService.to.client
    //       .queryUsers(filter: Filter.equal('id', chatWith));
    // final streamUserDetails = _streamUserData.users.firstWhereOrNull((element) => element.id == chatWith);
    
    change(state);
    log(channel.toString());
    _init();
    super.onInit();
  }

  void _init() async {
    // Channel _channel = _communicationService.client.channel(
    //   'messaging',
    //   id: '${value!.chatWithUser!.id.hashCode}${value!.currentUser.id.hashCode}',
    //   extraData: {
    //     'isGroupChat': false,
    //     'presence': true,
    //     'members': [
    //       value!.chatWithUser!.id,
    //       value!.currentUser.id,
    //     ],
    //   },
    // );
    try {
 await value!.currentChannel.watch();
    // await value!.currentChannel.markRead();
    change(
      value!.copyWith(currentChannel: value!.currentChannel),
      status: RxStatus.success(),
    );

    }catch(e) {
      print(e);
    }
     }
}
