import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/chat_view.dart';
import 'package:reel_ro/app/modules/chat/controllers/chat_list_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../utils/empty_widget.dart';
import '../../../widgets/loading.dart';
import '../../notification_screen.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);
  final controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
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
                          icon: const Icon(Icons.notifications)),
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
                      debugPrint('2121 ${items.length}');
                      Member? _member = items[index]
                          .state!
                          .members
                          .firstWhereOrNull((element) =>
                              element.user!.id !=
                              items[index].client.state.currentUser!.id);
                      debugPrint('2121 ${_member}');
                      var lastMessage = items[index]
                          .state
                          ?.messages
                          .reversed
                          .firstWhere((message) => !message.isDeleted,
                              orElse: () => Message(id: "0", text: ''));
                      final subtitle = lastMessage!.text;
                      // orElse: () => 'No matching color found');
                      // var subtitle =
                      //     items[index].state?.messages.reversed.first.text
                      //         '';

                      // debugPrint('2121 ${subtitle.toString()}');
                      // final subtitle = lastMessage == null
                      //     ? 'nothing yet'
                      //     : lastMessage.text!;
                      var profileUrl = _member?.user?.extraData['profilePic'];
                      return defaultWidget.copyWith(
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
                          subtitle!,
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
                        (BuildContext context, StreamChatError error) {
                      if (error.message.contains('does not exist')) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Initializing..',
                                style: TextStyle(fontSize: 16)),
                            SizedBox(
                              height: 20,
                            ),
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text("Error: ${error.message}"),
                        );
                      }
                    },
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
