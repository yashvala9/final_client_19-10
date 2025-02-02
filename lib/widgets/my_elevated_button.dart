import 'package:flutter/material.dart';
import 'package:reel_ro/utils/colors.dart';

class MyElevatedButton extends StatelessWidget {
  final String buttonText;
  final double? height;
  final TextStyle? style;

  final Function() onPressed;
  const MyElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.055, 0.72],
            colors: AppColors.buttonGradiantColor,
          ),
          color: Colors.deepPurple.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: height != null
              ? ElevatedButton.styleFrom(minimumSize: Size.fromHeight(height!))
              : null,
          child: Text(
            buttonText,
            style: style,
          ),
        ));
  }
}
