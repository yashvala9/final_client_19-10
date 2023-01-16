import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/chat_state/chat_list_state.dart';

import '../../../../repositories/profile_repository.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/communication_services.dart';

class ChatListController extends GetxController with StateMixin<ChatListState> {
  final _authService = Get.find<AuthService>();
  String? get token => _authService.token;
  final CommunicationService _communicationService = CommunicationService.to;
  int endTime = 0;

  @override
  ChatListState get state => ChatListState.initial(
        chatClient: _communicationService.client,
        currentStreamUser: _communicationService.client.state.currentUser!,
      );
  @override
  void onInit() async {
    endTime = DateTime.parse(await ProfileRepository().getEntryModel(token!))
        .millisecondsSinceEpoch;
    change(state, status: RxStatus.success());
    super.onInit();
  }
}
