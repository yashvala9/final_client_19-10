import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/chat_state/chat_list_state.dart';

import '../../../../services/communication_services.dart';

class ChatListController extends GetxController with StateMixin<ChatListState> {
  final CommunicationService _communicationService = CommunicationService.to;

  @override
  ChatListState get state => ChatListState.initial(
        chatClient: _communicationService.client,
        currentStreamUser: _communicationService.client.state.currentUser!,
      );
  @override
  void onInit() {
    change(state, status: RxStatus.success());
    super.onInit();
  }
}
