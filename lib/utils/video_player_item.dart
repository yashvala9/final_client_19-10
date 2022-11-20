import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/video_progress_indicator.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock/wakelock.dart';

import '../repositories/reel_repository.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final int videoId;
  final VoidCallback doubleTap;
  final VoidCallback? onTap;
  final VoidCallback swipeRight;
  final VoidCallback updatePoints;
  final bool showLike;
  final bool isReel;
  final bool enableAudio;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.videoId,
    required this.doubleTap,
    required this.swipeRight,
    this.enableAudio = true,
    this.onTap,
    required this.updatePoints,
    required this.isReel,
    this.showLike = false,
  }) : super(key: key);

  @override
  VideoPlayerItemState createState() => VideoPlayerItemState();
}

class VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController controller;
  final _authService = Get.find<AuthService>();
  final _reelRepo = Get.find<ReelRepository>();
  int updated = 0;

  String? get token => _authService.token;

  bool isManualPause = false;

  bool loading = true;
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    controller = VideoPlayerController.network(
      widget.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((value) {
        setState(() {
          loading = false;
        });
        controller.setVolume(widget.enableAudio ? 1 : 0);
        controller.dataSource;
        controller.setLooping(true);

        Wakelock.enable();
      });
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    controller.dispose();
  }

  void updateEntryPoints(int seconds, int totalSeconds) {
    if (widget.isReel) {
      _reelRepo.updateReelHistory(
          seconds, totalSeconds, widget.videoId, token!);
    } else {
      _reelRepo.updateAdsHistory(seconds, totalSeconds, widget.videoId, token!);
      widget.updatePoints();
    }
    updated = seconds;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() async {
      if (controller.value.position.inSeconds ==
              (controller.value.duration.inSeconds - 1) &&
          // (videoPlayerController.value.position.inSeconds.remainder(5) == 0) &&
          controller.value.position.inSeconds != 0 &&
          updated != controller.value.position.inSeconds) {
        updateEntryPoints(controller.value.position.inSeconds,
            controller.value.duration.inSeconds);
      }
    });

    return controller.value.isBuffering || loading
        ? Loading(
            isWhite: true,
          )
        : SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    widget.doubleTap();
                  },
                  onPanUpdate: (details) {
                    if (details.delta.dx < 0) {
                      widget.swipeRight();
                    }
                  },
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!();
                      return;
                    }
                    if (controller.value.isPlaying) {
                      controller.pause();

                      Wakelock.disable();
                      isManualPause = true;
                    } else {
                      controller.play();
                      Wakelock.enable();
                      isManualPause = false;
                    }
                  },
                  child: VisibilityDetector(
                    key: Key(DateTime.now().toString()),
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (info.visibleFraction == 0 && !isManualPause) {
                        controller.pause();

                        Wakelock.disable();
                      } else {
                        if (!isManualPause) {
                          controller.play();
                          Wakelock.enable();
                        }
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        SizedBox.expand(
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: controller.value.size.width,
                                  height: controller.value.size.height,
                                  child: VideoPlayer(controller),
                                ))),
                        if (!widget.isReel)
                          CustomVideoProgressIndicator(controller,
                              allowScrubbing: false),
                      ],
                    ),
                  ),
                ),
                widget.showLike
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 100,
                      )
                    : const SizedBox(),
              ],
            ),
          );
  }
}
