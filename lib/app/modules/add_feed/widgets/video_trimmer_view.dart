// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../../../../widgets/my_elevated_button.dart';
import '../add_feed_screen.dart';

class VideoTrimmerView extends StatefulWidget {
  final File file;

  const VideoTrimmerView(this.file, {Key? key}) : super(key: key);

  @override
  VideoTrimmerViewState createState() => VideoTrimmerViewState();
}

class VideoTrimmerViewState extends State<VideoTrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  final RxBool isPlaying = false.obs;
  final RxBool _progressVisibility = false.obs;

  String finalVideoPath = '';
  Future<void> pauseVideo() async {
    if (isPlaying.value) {
      bool playbackState = await _trimmer.videPlaybackControl(
        startValue: _startValue,
        endValue: _endValue,
      );
      isPlaying.value = playbackState;
    }
  }

  Future<String?> _saveVideo() async {
    _progressVisibility.value = true;

    String? _value;

    await _trimmer
        .saveTrimmedVideo(
            startValue: _startValue,
            endValue: _endValue,
            onSave: (String? outputPath) async {
              finalVideoPath = outputPath!;
              if (isPlaying.value) {
                bool playbackState = await _trimmer.videPlaybackControl(
                  startValue: _startValue,
                  endValue: _endValue,
                );
                isPlaying.value = playbackState;
              }
              Get.to(
                () => AddFeedScreen(
                  file: File(finalVideoPath),
                  type: 0,
                ),
              );
            })
        .then((value) {
      _progressVisibility.value = false;
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Trimmer"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Obx(
            () => Container(
              color: Colors.black,
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Visibility(
                    visible: _progressVisibility.value,
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: VideoViewer(trimmer: _trimmer),
                  ),
                  Center(
                    child: TrimEditor(
                      trimmer: _trimmer,
                      viewerHeight: 50.0,
                      viewerWidth: Get.mediaQuery.size.width,
                      maxVideoLength: const Duration(seconds: 65),
                      onChangeStart: (value) {
                        _startValue = value;
                      },
                      onChangeEnd: (value) {
                        _endValue = value;
                      },
                      onChangePlaybackState: (value) {
                        isPlaying.value = value;
                      },
                    ),
                  ),
                  TextButton(
                    child: isPlaying.value
                        ? const Icon(
                            Icons.pause,
                            size: 80.0,
                            color: Colors.amber,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.amber,
                          ),
                    onPressed: () async {
                      bool playbackState = await _trimmer.videPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      isPlaying.value = playbackState;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MyElevatedButton(
                      onPressed: () async {
                        _progressVisibility.value ? '' : await _saveVideo();
                        isPlaying.value = false;
                      },
                      buttonText: 'Save',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
