import 'package:flutter/material.dart';
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
        : Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
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
                    child: VideoPlayer(videoPlayerController)),
              widget.showLike?  const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 100,
                ): const SizedBox(),
              ],
            ),
          );
  }
}
