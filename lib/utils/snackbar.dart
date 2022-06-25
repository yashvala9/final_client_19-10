import 'package:flutter/material.dart';

import '../main.dart';

void showSnackBar(String message, {Color color = Colors.green}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(
      seconds: 3,
    ),
    backgroundColor: color,
  );
  snackbarKey.currentState?.showSnackBar(
    snackBar,
  );
}
