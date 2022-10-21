import 'dart:developer';

import 'package:get/get.dart';
import 'package:reel_ro/app/data/demo_data.dart';
import 'package:reel_ro/repositories/giveaway_repository.dart';

import '../../../../services/auth_service.dart';

class MyContestController extends GetxController {
  final _authService = Get.put(AuthService());
  final _giveawayRepo = Get.put(GiveawayRepository());
  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  int _count = 0;
  int get count => _count;
  set count(int count) {
    _count = count;
    update();
  }

  List<ContestDates> _contestDatesList = [];
  List<ContestDates> get contestDatesList => _contestDatesList;
  set contestDatesList(List<ContestDates> contestDatesList) {
    _contestDatesList = contestDatesList;
    update();
  }

  @override
  void onInit() {
    _fetch();
    super.onInit();
  }

  _fetch() async {
    await getContestDates();
  }

  Future<void> getContestDates() async {
    contestDatesList.clear();
    loading = true;
    try {
      await Future.delayed(1000.milliseconds, () async {
        contestDatesList.addAll(DemoData.demoContestDatesList);
      });
    } catch (e) {
      log("getContestDatesError: $e");
    }
    loading = false;
  }

  Future<void> deleteContest(int contestId) async {
    contestDatesList.clear();
    loading = true;
    try {
      await _giveawayRepo.deleteContest(contestId, token!);
      Get.back(result: true);
    } catch (e) {
      log("getContestDatesError: $e");
    }
    loading = false;
  }

  @override
  void onClose() {}
  void increment() => count++;
}
