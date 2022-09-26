import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();

  Rx<ConnectivityResult> connectionStatus = Rx<ConnectivityResult>(
    ConnectivityResult.none,
  );

  @override
  void onInit() {
    connectionStatus.bindStream(_connectivity.onConnectivityChanged);
    super.onInit();
  }
}
