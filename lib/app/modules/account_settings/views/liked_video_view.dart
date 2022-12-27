import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:reel_ro/repositories/profile_repository.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/empty_widget.dart';
import '../../../../utils/snackbar.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/my_elevated_button.dart';
import '../../search/widget/search_tag_tile.dart';
import '../../single_feed/single_feed_screen.dart';
import '../controllers/account_settings_controller.dart';

class LikedVideoView extends StatelessWidget {
  LikedVideoView({Key? key}) : super(key: key);

  final controller = Get.put(AccountSettingsController());
  final _formKey = GlobalKey<FormState>();

  final parser = EmojiParser();
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Liked Videos",
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              Expanded(
                child: Obx(
                  () => controller.isLVideoLoading.value
                      ? Loading()
                      : controller.likedReels.isEmpty
                          ? const EmptyWidget("No details found")
                          : ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                controller.likedReels.length,
                                (index) => ListTile(
                                  onTap: () => Get.to(
                                    () => SingleFeedScreen(
                                        null,
                                        [controller.likedReels[index]],
                                        0,
                                        null),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  leading: FutureBuilder<String>(
                                    future: ProfileRepository().getThumbnail(
                                        controller.likedReels[index].thumbnail),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          snapshot.data!,
                                        ),
                                      );
                                    },
                                  ),
                                  title: Text(
                                    parser.emojify(controller
                                        .likedReels[index].video_title),
                                    style: style.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    parser.emojify(
                                      controller.likedReels[index].description,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ).toList(),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
