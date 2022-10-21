import 'package:flutter/material.dart';
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
    final theme = Get.theme;
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
                  return defaultMessageWidget.copyWith(
                      messageTheme: defaultMessageWidget.messageTheme.copyWith(
                          messageTextStyle: TextStyle(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black),
                          messageBackgroundColor: isCurrentUser
                              ? colorSchem.primary
                              : colorSchem.primaryContainer));
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
        return StreamChannel(
          channel: state!.currentChannel,
          child: Scaffold(
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
