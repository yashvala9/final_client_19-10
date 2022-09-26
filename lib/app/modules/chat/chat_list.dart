import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/chat_view.dart';
import 'package:reel_ro/app/modules/chat/controllers/chat_list_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../utils/base.dart';
import '../../../utils/empty_widget.dart';
import '../../../widgets/loading.dart';
import '../../notification_screen.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);
  final controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;
    return Scaffold(
      body: controller.obx(
        (state) => RefreshIndicator(
          onRefresh: state!.individualChannelsListController.refresh,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Inbox",
                        style: style.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                          onPressed: () => Get.to(
                                () => NotificationScreen(),
                              ),
                          icon: const Icon(Icons.edit)),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search messages..."),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: StreamChannelListView(
                    controller: state.individualChannelsListController,
                    itemBuilder: (BuildContext context, List<Channel> items,
                        int index, StreamChannelListTile defaultWidget) {
                      Member? _member = items[index]
                          .state!
                          .members
                          .firstWhereOrNull((element) =>
                              element.user!.id !=
                              items[index].client.state.currentUser!.id);
                      var lastMessage =
                          items[index].state?.messages.reversed.firstWhere(
                                (message) => !message.isDeleted,
                              );
                      final subtitle = lastMessage == null
                          ? 'nothing yet'
                          : lastMessage.text!;
                      var profileUrl = _member?.user?.extraData['profilePic'];
                      return defaultWidget.copyWith(
                        // onLongPress: () {
                        //   final channel = state
                        //       .individualChannelsListController.client
                        //       .channel('messaging', id: items[index].id);
                        // },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: colorSchem.primary,
                          backgroundImage: NetworkImage(
                            (profileUrl != "" &&
                                        profileUrl.toString().contains('https')
                                    ? profileUrl
                                    : "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80")
                                .toString(),
                          ),
                        ),
                        title: Text(
                          (_member?.user?.extraData['fullName'] ??
                                  items[index].cid)
                              .toString(),
                          style: style.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                      );
                    },
                    emptyBuilder: (context) =>
                        const EmptyWidget("No Communication"),
                    loadingBuilder: (context) => const Loading(),
                    errorBuilder:
                        (BuildContext context, StreamChatError error) => Center(
                      child: Text("Error: ${error.message}"),
                    ),
                    onChannelTap: (channel) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChannelPage(
                          channel: channel,
                        );
                      }));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// class ChatList extends StatelessWidget {
//   ChatList({Key? key}) : super(key: key);

//   final controller = Get.put(ChatListController());

//   Widget _buildIndividualsList(BuildContext context, ChatListState state) {
//     return RefreshIndicator(
//       child: StreamChannelListView(
//         controller: state.individualChannelsListController,
//         itemBuilder: (BuildContext context, List<Channel> items, int index,
//             StreamChannelListTile defaultWidget) {
//           Member? _member = items[index].state!.members.firstWhereOrNull(
//               (element) =>
//                   element.user!.id !=
//                   items[index].client.state.currentUser!.id);

//           return defaultWidget.copyWith(
//             title: Text(
//               (_member?.user?.extraData['fullName'] ?? items[index].cid)
//                   .toString(),
//             ),
//           );
//         },
//         padding: EdgeInsets.symmetric(
//           horizontal: Get.width * 0.05,
//           vertical: Get.height * 0.01,
//         ),
//         emptyBuilder: (context) => const EmptyWidget("No Communication"),
//         loadingBuilder: (context) => const Loading(),
//         errorBuilder: (BuildContext context, StreamChatError error) => Center(
//           child: Text("Error: ${error.message}"),
//         ),
//         // onChannelTap: (Channel _channel) {
//         // Member? _member = _channel.state!.members.firstWhereOrNull((element) =>
//         //     element.user!.id != _channel.client.state.currentUser!.id);
//         // if (_member != null && _member.user != null) {
//         //   ChatView.open(
//         //     chatWithUserStreamDetails: _member.user!,
//         //   );
//         // }
//         // },
//         // onChannelTap: (Channel _channel) => ChatView.open(
//         //   channel: _channel,
//         // ),
//       ),
//       onRefresh: state.individualChannelsListController.refresh,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: controller.obx(
//         (state) => _buildIndividualsList(context, state!),
//       ),
//     );
//   }
// }
