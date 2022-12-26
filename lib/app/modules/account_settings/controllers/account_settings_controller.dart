import 'dart:developer';

import 'package:get/get.dart';
import 'package:reel_ro/models/blocked_users_model.dart';
import 'package:reel_ro/models/contest_model.dart';
import 'package:reel_ro/models/likedreel_model.dart';
import 'package:reel_ro/repositories/profile_repository.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../../../services/auth_service.dart';

class AccountSettingsController extends GetxController {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _authService = Get.put(AuthService());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  String message = '';

  bool loading = false;

  RxBool isbUserLoading = false.obs;

  String password = '';
  String newPassword = '';
  String confirmPassword = '';

  List<LikedreelModel> likedReels = [];
  List<BlockedusersModel> blockedUsers = [];

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
    getBlockedUsers();
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

  Future<void> getBlockedUsers() async {
    try {
      isbUserLoading(true);
      blockedUsers.clear();
      var v = await ProfileRepository().getBlockedUsers(token!);
      printInfo(info: v.toString());

      blockedUsers = v;
      isbUserLoading(false);
    } catch (e) {
      log("getBlockedUsers: $e");
    }
  }
}
