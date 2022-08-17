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
    print('2121 $v[0] $v[1] ');
    return v[1];
  }
}
