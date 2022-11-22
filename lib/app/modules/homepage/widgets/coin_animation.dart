import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reel_ro/utils/assets.dart';

class CoinAnimation extends StatefulWidget {
  CoinAnimation(this.i, {Key? key}) : super(key: key);
  int i;

  @override
  State<CoinAnimation> createState() => _CoinAnimationState();
}

class _CoinAnimationState extends State<CoinAnimation>
    with TickerProviderStateMixin {
  FlipCardController coinController = FlipCardController();
  @override
  void initState() {
    super.initState();

    coinController.state = FlipCardState();
    coinController.state!.controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..forward()
          ..addListener(() {
            if (coinController.state!.controller!.isCompleted) {
              coinController.state!.controller!.repeat();
            }
          });

    WidgetsBinding.instance.addPostFrameCallback((_) => coinController
        .state!.controller!
        .repeat()); //i add this to access the context safely.
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      speed: 2000,
      controller: coinController,
      direction: FlipDirection.HORIZONTAL,
      front: CoinWidget(widget.i),
      back: CoinWidget(widget.i),
    );
  }
}

class CoinWidget extends StatelessWidget {
  CoinWidget(
    this.i, {
    Key? key,
  }) : super(key: key);
  int i;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(Assets.coin2),
          Text(
            i.toString(),
            style: const TextStyle(
                color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
