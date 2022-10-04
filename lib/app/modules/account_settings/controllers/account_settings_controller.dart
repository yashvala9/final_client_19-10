import 'dart:developer';

import 'package:get/get.dart';
import 'package:reel_ro/models/contest_model.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../../../services/auth_service.dart';

class AccountSettingsController extends GetxController {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _authService = Get.put(AuthService());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  ContestModel? _contestModel;
  ContestModel? get contestModel => _contestModel;
  set contestModel(ContestModel? contestModel) {
    _contestModel = contestModel;
    update();
  }

  @override
  void onInit() {
    contestModel = null;
    getContestByUser();
    super.onInit();
  }

  Future<void> getContestByUser() async {
    try {
      contestModel = null;
      var v = await _giveawayRepo.getContestsByUserId(profileId!, token!);
      printInfo(info: v.toString());

      contestModel = v;
    } catch (e) {
      log("getContestByUserIdError: $e");
    }
  }
}
