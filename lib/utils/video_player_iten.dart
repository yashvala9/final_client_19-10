import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final VoidCallback doubleTap;
  final VoidCallback swipeRight;
  final bool showLike;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.doubleTap,
    required this.swipeRight,
    this.showLike = false,
  }) : super(key: key);

  @override
  VideoPlayerItemState createState() => VideoPlayerItemState();
}

class VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  bool isManualPause = false;
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      // videoPlayerController = VideoPlayerController.asset("assets/V1.mp4")
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.dataSource;
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return videoPlayerController.value.isBuffering
        ? const Loading()
        : SizedBox(
            width: double.infinity,
            // decoration: const BoxDecoration(
            //   color: Colors.black,
            // ),
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
                    if (videoPlayerController.value.isPlaying) {
                      videoPlayerController.pause();
                      Wakelock.disable();
                      isManualPause = true;
                    } else {
                      videoPlayerController.play();
                      Wakelock.enable();
                      isManualPause = false;
                    }
                  },
                  child: VisibilityDetector(
                      key: Key(DateTime.now().toString()),
                      onVisibilityChanged: (VisibilityInfo info) {
                        if (info.visibleFraction == 0 && !isManualPause) {
                          videoPlayerController.pause();
                          Wakelock.disable();
                        } else {
                          if (!isManualPause) {
                            videoPlayerController.play();
                            Wakelock.enable();
                          }
                        }
                      },
                      child: VideoPlayer(videoPlayerController)),
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

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final VoidCallback doubleTap;
  final bool showLike;
  const VideoPlayerWidget({
    Key? key,
    required this.url,
    required this.doubleTap,
    this.showLike = false,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  late BetterPlayerController _betterPlayerController;

  final _authService = Get.find<AuthService>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    log("URL: ${widget.url}");
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 5.3 / 10,
        looping: true,
        autoPlay: true,
        deviceOrientationsOnFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        allowedScreenSleep: false,
        fullScreenAspectRatio: 5.3 / 10,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableAudioTracks: false,
          enableMute: false,
          enableOverflowMenu: false,
          enableFullscreen: false,
          enablePip: false,
          enablePlaybackSpeed: false,
          enableProgressBar: false,
          enableProgressBarDrag: false,
          enableProgressText: false,
          enableQualities: false,
          enableSkips: false,
          enableSubtitles: false,
          enableRetry: true,
          enablePlayPause: false,
          controlBarColor: Colors.black.withOpacity(0.2),
          playIcon: Icons.play_arrow_outlined,
          pauseIcon: Icons.pause_circle_outline,
        ),
        autoDispose: false,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.url,
        videoFormat: BetterPlayerVideoFormat.hls,
        drmConfiguration: BetterPlayerDrmConfiguration(
          drmType: BetterPlayerDrmType.token,
          token: "Bearer=${_authService.token}",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose(forceDispose: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onDoubleTap: () {
            widget.doubleTap();
          },
          onTap: () {
            // if (videoPlayerController.value.isPlaying) {
            //   videoPlayerController.pause();
            // } else {
            //   videoPlayerController.play();
            // }
          },
          child: BetterPlayer(
            controller: _betterPlayerController,
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
    );
  }
}
