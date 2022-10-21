import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final list = [
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    false,
    false,
    true,
    true,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    final colorSchem = theme.colorScheme;

    final bottom = Get.mediaQuery.viewInsets.bottom;
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 80,
        iconTheme: const IconThemeData(color: Colors.black),
        title: ListTile(
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
          subtitle: const Text("Online"),
        ),
      ),
      body: CustomScrollView(
        reverse: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(2),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                list.map((e) {
                  if (e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(),
                          Flexible(
                            flex: 3,
                            child: Material(
                              color: colorSchem.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "Oh it's okay i like it too babe",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Material(
                              color: colorSchem.primaryContainer,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "Hi, thanks for accompanying me today. really enjoyed today i like it",
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    );
                  }
                }).toList(),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Material(
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Type something..."),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: RawMaterialButton(
                    onPressed: () {},
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    fillColor: theme.primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
