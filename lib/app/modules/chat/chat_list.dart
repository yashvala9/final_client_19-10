import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/chat/chat_view.dart';
import 'package:reel_ro/app/modules/chat/controllers/chat_list_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../utils/colors.dart';
import '../../../utils/empty_widget.dart';
import '../../../widgets/loading.dart';
import '../../notification_screen.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);
  final controller = Get.put(ChatListController());
  // int endTime = DateTime.now().millisecondsSinceEpoch + 5000 * 30 * 60 * 24;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Next Lucky Draw',
              style: style.titleMedium!.copyWith(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Column(children: [
          Image.network(
            "https://reelro-image-bucket.s3.ap-south-1.amazonaws.com/images/194034/ConciousPlanet-SaveSoil_AppIcons_Round_V2.png",
            fit: BoxFit.fitHeight,
            height: 200,
          ),
          Text(
            'Prize Name',
            style: style.headline5!.copyWith(
              color: AppColors.winnercardpink,
            ),
          ),
          Image.network(
            "https://reelro-image-bucket.s3.ap-south-1.amazonaws.com/images/194034/ConciousPlanet-SaveSoil_AppIcons_Round_V2.png",
            fit: BoxFit.fitHeight,
            height: 200,
          ),
          Text(
            'Buddy Prize Name',
            style: style.headline5!.copyWith(
              color: AppColors.winnercardpink,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 64, 255),
                      Color(0xFF00CCFF),
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CountdownTimer(
                    widgetBuilder: (context, time) {
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            timeBox(time!.days.toString(), 'Day'),
                            colon(),
                            timeBox(time.hours.toString(), 'Hour'),
                            colon(),
                            timeBox(time.min.toString(), 'Minute'),
                            colon(),
                            timeBox(time.sec.toString(), 'Second'),
                          ],
                        ),
                      );
                    },
                    endTime: controller.endTime,
                    textStyle: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );

    // return Scaffold(
    //   body: controller.obx(
    //     (state) => RefreshIndicator(
    //       onRefresh: state!.individualChannelsListController.refresh,
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(
    //                 top: 16,
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     "Inbox",
    //                     style: style.titleMedium!.copyWith(
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                   IconButton(
    //                       onPressed: () => Get.to(
    //                             () => NotificationScreen(),
    //                           ),
    //                       icon: const Icon(Icons.notifications)),
    //                 ],
    //               ),
    //             ),
    //             const Divider(),
    //             // Padding(
    //             //   padding: const EdgeInsets.symmetric(horizontal: 4),
    //             //   child: TextFormField(
    //             //     decoration: const InputDecoration(
    //             //         prefixIcon: Icon(Icons.search),
    //             //         hintText: "Search messages..."),
    //             //   ),
    //             // ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             Expanded(
    //               child: StreamChannelListView(
    //                 controller: state.individualChannelsListController,
    //                 itemBuilder: (BuildContext context, List<Channel> items,
    //                     int index, StreamChannelListTile defaultWidget) {
    //                   debugPrint('2121 ${items.length}');
    //                   Member? _member = items[index]
    //                       .state!
    //                       .members
    //                       .firstWhereOrNull((element) =>
    //                           element.user!.id !=
    //                           items[index].client.state.currentUser!.id);
    //                   debugPrint('2121 $_member');
    //                   var lastMessage = items[index]
    //                       .state
    //                       ?.messages
    //                       .reversed
    //                       .firstWhere((message) => !message.isDeleted,
    //                           orElse: () => Message(id: "0", text: ''));
    //                   final subtitle = lastMessage!.text;
    //                   var profileUrl = _member?.user?.extraData['profilePic'];
    //                   return defaultWidget.copyWith(
    //                     leading: CircleAvatar(
    //                       radius: 25,
    //                       backgroundColor: colorSchem.primary,
    //                       backgroundImage: NetworkImage(
    //                         (profileUrl != "" &&
    //                                     profileUrl.toString().contains('https')
    //                                 ? profileUrl
    //                                 : "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80")
    //                             .toString(),
    //                       ),
    //                     ),
    //                     title: Text(
    //                       (_member?.user?.extraData['fullName'] ??
    //                               items[index].cid)
    //                           .toString(),
    //                       style: style.titleMedium!.copyWith(
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                     ),
    //                     subtitle: Text(
    //                       subtitle!,
    //                       maxLines: 2,
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                     contentPadding: const EdgeInsets.symmetric(
    //                         vertical: 8, horizontal: 8),
    //                   );
    //                 },
    //                 emptyBuilder: (context) =>
    //                     const EmptyWidget("No Communication"),
    //                 loadingBuilder: (context) => Loading(),
    //                 errorBuilder:
    //                     (BuildContext context, StreamChatError error) {
    //                   if (error.message.contains('does not exist')) {
    //                     return Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: const [
    //                         Text('Initializing..',
    //                             style: TextStyle(fontSize: 16)),
    //                         SizedBox(
    //                           height: 20,
    //                         ),
    //                         Center(child: CircularProgressIndicator()),
    //                       ],
    //                     );
    //                   } else {
    //                     return Center(
    //                       child: Text("Error: ${error.message}"),
    //                     );
    //                   }
    //                 },
    //                 onChannelTap: (channel) {
    //                   Navigator.push(context,
    //                       MaterialPageRoute(builder: (context) {
    //                     return ChannelPage(
    //                       channel: channel,
    //                     );
    //                   }));
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Column colon() {
    return Column(
      children: const [
        Text(':', style: TextStyle(fontSize: 28, color: Colors.white)),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget timeBox(String time, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300]!,
                border: Border.all(
                  color: Colors.grey[100]!,
                  width: 2.0,
                ),
              ),
              child: Center(
                  child: Text(
                time,
                style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
