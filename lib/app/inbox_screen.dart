import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/notification_screen.dart';
import 'package:reel_ro/widgets/chart_tile.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                              () => const NotificationScreen(),
                            ),
                        icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search messages..."),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(
                    20,
                    (index) => const ChatTile(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
