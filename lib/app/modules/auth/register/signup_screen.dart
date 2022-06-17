import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/widgets/loading.dart';

import '../../../routes/app_routes.dart';
import '../auth_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: GetX<AuthController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Email"),
                    ),
                    validator: (v) => v!.isEmpty ? "Email is required" : null,
                    onSaved: (v) => _controller.email = v!.trim(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: !_controller.obsecure.value,
                    decoration: InputDecoration(
                        label: const Text("Password"),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _controller.obsecure.value =
                                  !_controller.obsecure.value;
                            },
                            icon: Icon(!_controller.obsecure.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined))),
                    validator: (v) =>
                        v!.isEmpty ? "Password is required" : null,
                    onSaved: (v) => _controller.password = v!.trim(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _controller.loading.value
                      ? const Loading()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _controller.signup();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                          ),
                          child: const Text("Signup"),
                        ),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.login);
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
