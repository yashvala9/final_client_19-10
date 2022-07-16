import 'package:get/get.dart';
import 'package:reel_ro/models/contest_model.dart';
import 'package:reel_ro/utils/snackbar.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../../../services/auth_service.dart';

class AccountSettingsController extends GetxController {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _authService = Get.put(AuthService());
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;
  ContestModel? contestModel;
  @override
  void onInit() {
    // TODO: implement onInit
    getContestByUser();
    super.onInit();
  }

  void getContestByUser() async {
    showSnackBar('running getcontestbyuser');
    contestModel = await _giveawayRepo.getContestsByUserId(profileId!, token!);
    showSnackBar(contestModel!.contestName);
  }
}
