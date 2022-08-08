import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reel_ro/services/auth_service.dart';

import '../../../main.dart';

class SplashController extends GetxController {
  PackageInfo get packageInfo => kPackageInfo;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), _redirectUser);
    super.onInit();
  }

  void _redirectUser() {
    final _services = Get.put(AuthService(), permanent: true);
    _services.redirectUser();
  }
}
