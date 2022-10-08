import 'package:get/get.dart';

import '../../../../repositories/reel_repository.dart';
import '../../../../services/auth_service.dart';

class FollowerPickerController extends GetxController {
  final _authService = Get.put(AuthService());
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;
  final _reelRepo = Get.find<ReelRepository>();

  Future<String> setRandomWinner(String contestId) async {
    var v = await _reelRepo.setRandomWinner(contestId, token!);
    return v[1];
  }
}
