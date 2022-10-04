import 'package:get/get.dart';
import 'package:reel_ro/models/ads_history_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import '../../../services/auth_service.dart';

class AdsHistoryController extends GetxController {
  final _authService = Get.find<AuthService>();

  ProfileModel get profileModel => _authService.profileModel!;

  late List<AdsHistoryModel> adsHistory = [];

  int? get profileId => _authService.profileModel?.id;
  String? get token => _authService.token;

  bool loadingMore = false;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }
}
