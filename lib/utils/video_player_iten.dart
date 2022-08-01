import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reel_ro/widgets/loading.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final VoidCallback doubleTap;
  final bool showLike;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.doubleTap,
    this.showLike = false,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return videoPlayerController.value.isBuffering
        ? const Loading()
        : SizedBox(
            width: double.infinity,
            height: double.infinity,
            // decoration: const BoxDecoration(
            //   color: Colors.black,
            // ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onDoubleTap: () {
                    widget.doubleTap();
                  },
                  onTap: () {
                    if (videoPlayerController.value.isPlaying) {
                      videoPlayerController.pause();
                    } else {
                      videoPlayerController.play();
                    }
                  },
                  child: VideoPlayer(videoPlayerController),
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
