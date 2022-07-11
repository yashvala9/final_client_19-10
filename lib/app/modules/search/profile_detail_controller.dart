import 'package:get/get.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/profile_repository.dart';
import '../../../services/auth_service.dart';

class ProfileDetailController extends GetxController{
  final _authService = Get.find<AuthService>();
  final _profileRepo = Get.put(ProfileRepository());
  final _authRepo = Get.put(AuthRepository());

  int? get profileId => _authService.profileModel?.id;
  String? get token => _authService.token;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }
}