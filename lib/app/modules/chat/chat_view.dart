import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/controllers/chat_controller.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'bindings/chat_bindings.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({Key? key, required this.channel}) : super(key: key);

  final Channel channel;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  @override
  void initState() {
    widget.channel.watch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;
    return StreamChannel(
      channel: widget.channel,
      child: Scaffold(
        appBar: const StreamChannelHeader(
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamMessageListView(
                messageBuilder: (
                  BuildContext context,
                  MessageDetails details,
                  List<Message> messages,
                  StreamMessageWidget defaultMessageWidget,
                ) {
                  final message = details.message;
                  final isCurrentUser =
                      StreamChat.of(context).currentUser!.id ==
                          message.user!.id;
                  final textAlign =
                      isCurrentUser ? TextAlign.right : TextAlign.left;
                  final color = isCurrentUser ? Colors.blueGrey : Colors.blue;
                  return defaultMessageWidget.copyWith(
                      messageTheme: defaultMessageWidget.messageTheme.copyWith(
                          messageTextStyle: TextStyle(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black),
                          messageBackgroundColor: isCurrentUser
                              ? colorSchem.primary
                              : colorSchem.primaryContainer)
                      // messageTheme: StreamMessageThemeData(
                      // messageBackgroundColor: colorSchem.primary,
                      // messageTextStyle: const TextStyle(color: Colors.white),
                      // reactionsBackgroundColor: colorSchem.primaryContainer,
                      // ),
                      );
                },
              ),
            ),
            const StreamMessageInput(),
          ],
        ),
      ),
    );
  }
}

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  static void open({
    required Channel channel,
    // User? chatWithUserStreamDetails,
    // required User chatWithUserStreamDetails,
    Transition? transition,
  }) {
    Get.to(
      () => const ChatView(),
      binding: ChatBinding(channel: channel),
      transition: transition ?? Transition.downToUp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) {
        // return ChatWrapper(
        //   chatWith: state!.chatWith!,
        //   chatWithUserPrecense: state.chatWithUserPrecense,
        //   myInfo: state.loggedInUser!,
        //   messages: state.allMessages,
        //   onSend: controller.sendTextMessage,
        //   onPaginate: controller.loadOldMessages,
        // );
        return StreamChannel(
          channel: state!.currentChannel,
          child: Scaffold(
            // appBar: StreamChannelHeader(
            //   leading: _ChatBackButton(
            //     onPressed: () => Get.back(),
            //     showUnreads: true,
            //     cid: state.currentChannel!.cid,
            //   ),
            //   onTitleTap: () {},
            //   actions: [],
            // ),
            appBar: AppBar(
              title: Text(state.currentChannel.name!),
            ),
            body: Column(
              children: const <Widget>[
                Expanded(
                  child: StreamMessageListView(),
                ),
                StreamMessageInput(),
              ],
            ),
          ),
        );
      },
      onLoading: Scaffold(
        appBar: AppBar(),
        body: const Loading(),
      ),
      onError: (error) => EmptyWidget(
        error!,
      ),
    );
  }
}
