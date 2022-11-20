import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  bool isWhite;
  Loading({Key? key, this.isWhite = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isWhite
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const CircularProgressIndicator(),
    );
  }
}
