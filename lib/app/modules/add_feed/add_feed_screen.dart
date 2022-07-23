import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/add_feed/add_feed_controller.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';
import 'package:video_player/video_player.dart';

class AddFeedScreen extends StatefulWidget {
  final File file;
  final int type;
  const AddFeedScreen({Key? key, required this.file, required this.type})
      : super(key: key);

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    if (widget.type == 0) {
      videoPlayerController = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
          videoPlayerController.pause();
        });
    }
    super.initState();
  }

  final _controller = Get.put(AddFeedController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: GetBuilder<AddFeedController>(
            builder: (_) => Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Post",
                            style: style.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 200,
                        
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        child: widget.type == 1
                            ? Image.file(widget.file)
                            : VideoPlayer(videoPlayerController),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: "Title"),
                        onSaved: (v) => _controller.title = v!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(hintText: "Description"),
                        onSaved: (v) => _controller.description = v!,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _controller.loading
                        ? const Loading()
                        : MyElevatedButton(
                            buttonText: "Add",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                _controller.addFeed(widget.file, widget.type);
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
