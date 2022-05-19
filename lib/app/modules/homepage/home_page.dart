import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        actions: [
          IconButton(
              onPressed: () {
                _authService.signOut();
              },
              icon: const Icon(Icons.power_settings_new_outlined))
        ],
      ),
    );
  }
}
