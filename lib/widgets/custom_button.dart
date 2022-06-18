import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.style,
    required this.text,
    required this.iconImage,
    required this.onTap,
    this.color,
    this.border,
    this.buttonTextColor,
    this.space,
    this.width,
  }) : super(key: key);

  final TextTheme style;
  final String text;
  final String iconImage;
  final Function() onTap;
  final Color? color;
  final Border? border;
  final Color? buttonTextColor;
  final double? space;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? Get.width * 0.85,
        padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.02,
          horizontal: Get.width * 0.05,
        ),
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(iconImage, width: Get.width * 0.08),
            SizedBox(width: space ?? Get.width * 0.08),
            Text(
              text,
              textScaleFactor: Get.textScaleFactor,
              style: style.bodyMedium?.copyWith(
                color: buttonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
