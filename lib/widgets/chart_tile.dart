import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/chat_screen.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;
    return ListTile(
      onTap: () => Get.to(
        () => ChatScreen(),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      leading: CircleAvatar(
      radius: 25,
        backgroundColor: colorSchem.primary,
        backgroundImage: const NetworkImage(
          "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
        ),
      ),
      title: Text(
        "Sabrina Wah",
        style: style.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: const Text(
        "Hai, whats’up bro. hayu atuh hangout dei jang Sabrina",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: colorSchem.primary,
            radius: 8,
            child: const FittedBox(
                child: Text(
              "1",
              style: TextStyle(
                color: Colors.white,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "2:30pm",
              style: style.caption,
            ),
          )
        ],
      ),
    );
  }
}
