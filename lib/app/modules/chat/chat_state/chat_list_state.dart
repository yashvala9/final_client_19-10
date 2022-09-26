import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';


part 'chat_list_state.freezed.dart';



@freezed
class ChatListState with _$ChatListState {
  factory ChatListState({
    required StreamChannelListController individualChannelsListController,
    required StreamChannelListController groupChannelsListController,
  }) = _ChatListState;

  factory ChatListState.initial(
          {required StreamChatClient chatClient,
          required User currentStreamUser}) =>
      ChatListState(
        individualChannelsListController: StreamChannelListController(
          client: chatClient,
          filter: Filter.and([
            Filter.equal('isGroupChat', false),
            Filter.in_(
              'members',
              [currentStreamUser.id.toString()],
            ),
          ]),
           sort: [
            SortOption(
              'last_message_at',
              comparator: (a, b) =>
                  b.lastMessageAt!.compareTo(a.lastMessageAt!),
            ),
          ],
          limit: 15,
        ),
        groupChannelsListController: StreamChannelListController(
          client: chatClient,
          filter: Filter.and([
            Filter.equal('isGroupChat', true),
            Filter.in_(
              'members',
              [currentStreamUser.id.toString()],
            ),
          ]),
          sort: [
            SortOption(
              'last_message_at',
              comparator: (a, b) =>
                  b.lastMessageAt!.compareTo(a.lastMessageAt!),
            ),
          ],
          limit: 15,
        ),
      );
}
