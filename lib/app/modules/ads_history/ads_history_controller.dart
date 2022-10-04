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

  // Future<void> getMoreFeed(int skip) async {
  //   loadingMore = true;
  //     try {
  //       var newList = await _profileRepo.getReelByProfileId(profileId!, token!,
  //           limit: 9, skip: skip);
  //       if (newList.isEmpty) {
  //         _loadMore = false;
  //       } else {
  //         reelsLoaded.addAll(newList);
  //       }
  //     } catch (e) {
  //       showSnackBar(e.toString(), color: Colors.red);
  //       print("getFeeds: $e");
  //     }
  //   }
  //   loadingMore = false;
  // }
  // void getProfile() async {
  //   loading = true;
  //   try {
  //     profileModel = await _profileRepo.getProfileById(profileId!, token!);
  //   } catch (e) {
  //     showSnackBar(e.toString(), color: Colors.red);
  //     print("getProfile: $e");
  //   }
  //   loading = false;
  // }

  // void getReelsById() async{
  //   try {

  //   } catch (e) {
  //     print("getReelsById: $e");
  //   }
  // }
  // void signOut() async {
  //   await _authRepo.signOut();
  // }

  // void deleteReel(int reelId) async {
  //   try {
  //     await _reelRepo.deleteReel(reelId, token!);
  //     update();
  //   } catch (e) {
  //     print('delteReel: $e');
  //   }
  // }
}
