import 'package:get/get.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';

import '../../../../models/profile_model.dart';
import '../../../../services/auth_service.dart';

class ReferralsController extends GetxController {
  final _giveawayRepo = GiveawayRepository();
  final _authService = Get.put(AuthService());
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  List<ProfileModel> referrals = [];
  final count = 0.obs;
  @override
  void onInit() {
    getReferralList();
    super.onInit();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  void getReferralList() async {
    referrals = await _giveawayRepo.getReferrals(profileId!, token!);
  }
}
