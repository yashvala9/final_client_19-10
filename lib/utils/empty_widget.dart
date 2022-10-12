import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  final Color color;
  const EmptyWidget(this.text, {Key? key, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}
