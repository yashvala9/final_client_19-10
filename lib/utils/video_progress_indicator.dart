import 'package:flutter/material.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

/// Displays the play/buffering status of the video controlled by [controller].
///
/// If [allowScrubbing] is true, this widget will detect taps and drags and
/// seek the video accordingly.
///
/// [padding] allows to specify some extra padding around the progress indicator
/// that will also detect the gestures.
class CustomVideoProgressIndicator extends StatefulWidget {
  /// Construct an instance that displays the play/buffering status of the video
  /// controlled by [controller].
  ///
  /// Defaults will be used for everything except [controller] if they're not
  /// provided. [allowScrubbing] defaults to false, and [padding] will default
  /// to `top: 5.0`.
  const CustomVideoProgressIndicator(
    this.controller, {
    Key? key,
    this.colors = const VideoProgressColors(),
    required this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  }) : super(key: key);

  /// The [VideoPlayerController] that actually associates a video with this
  /// widget.
  final VideoPlayerController controller;

  /// The default colors used throughout the indicator.
  ///
  /// See [VideoProgressColors] for default values.
  final VideoProgressColors colors;

  /// When true, the widget will detect touch input and try to seek the video
  /// accordingly. The widget ignores such input when false.
  ///
  /// Defaults to false.
  final bool allowScrubbing;

  /// This allows for visual padding around the progress indicator that can
  /// still detect gestures via [allowScrubbing].
  ///
  /// Defaults to `top: 5.0`.
  final EdgeInsets padding;

  @override
  State<CustomVideoProgressIndicator> createState() =>
      _CustomVideoProgressIndicatorState();
}

class _CustomVideoProgressIndicatorState
    extends State<CustomVideoProgressIndicator> {
  _CustomVideoProgressIndicatorState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (final DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          SmoothVideoProgress(
            controller: controller,
            builder: (context, position, duration, _) => _VideoProgressSlider(
              position: position,
              duration: duration,
              controller: controller,
              swatch: Colors.greenAccent,
            ),
          ),
          // LinearProgressIndicator(
          //   value: maxBuffering / duration,
          //   valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
          //   backgroundColor: colors.backgroundColor,
          // ),
          // Container(
          //   width: MediaQuery.of(context).size.width * position / duration,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [
          //         Color.fromARGB(255, 231, 32, 58),
          //         Color.fromARGB(255, 237, 7, 7)
          //       ],
          //       stops: [
          //         0.1,
          //         0.5,
          //       ],
          //     ),
          //   ),
          //   child: SizedBox(
          //     height: 20.0,
          //   ),
          // ),
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: <Color>[Colors.black, Colors.blue]),
          //   ),
          //   child: LinearProgressIndicator(
          //     value: position / duration,
          //     valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
          //     backgroundColor: Colors.transparent,
          //   ),
          // ),
        ],
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 25,
            child: progressIndicator,
          ),
        ));
    if (widget.allowScrubbing) {
      return _VideoScrubber(
        controller: controller,
        child: paddedProgressIndicator,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}

class _VideoScrubber extends StatefulWidget {
  const _VideoScrubber({
    required this.child,
    required this.controller,
  });

  final Widget child;
  final VideoPlayerController controller;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying &&
            controller.value.position != controller.value.duration) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}

class _VideoProgressSlider extends StatelessWidget {
  const _VideoProgressSlider({
    required this.position,
    required this.duration,
    required this.controller,
    required this.swatch,
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;

  @override
  Widget build(BuildContext context) {
    final max = duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, max).toDouble();
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: swatch),
        useMaterial3: true,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * value / max,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[200]!, Colors.pink[600]!],
                stops: const [0.1, 0.5],
              ),
            ),
            //   child:
            // child: Slider(
            //   min: 0,
            //   max: max,
            //   value: value,
            //   onChanged: (value) =>
            //       controller.seekTo(Duration(milliseconds: value.toInt())),
            //   onChangeStart: (_) => controller.pause(),
            //   onChangeEnd: (_) => controller.play(),
            // ),
          ),
        ],
      ),
    );
  }
}
