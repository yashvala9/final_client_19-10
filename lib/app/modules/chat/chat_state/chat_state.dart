
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required Channel currentChannel,
    User? chatWithUser,
    required User currentUser,
  }) = _ChatState;
  // const factory ChatState({
  //   required String conversationID,
  //   ChatUserInfo? loggedInUser,
  //   ChatUserInfo? chatWith,
  //   ChatPresence? chatWithUserPrecense,
  //   required List<ChatMessage> allMessages,
  // }) = _ChatState;

  factory ChatState.initial(Channel channel) => ChatState(
        currentChannel: channel,
        chatWithUser: channel.state?.members
            .firstWhere((element) =>
                element.user?.id != channel.client.state.currentUser!.id)
            .user,
        currentUser: channel.client.state.currentUser!,
      );
}