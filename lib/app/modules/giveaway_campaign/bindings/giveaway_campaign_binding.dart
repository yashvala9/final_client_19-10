import 'package:get/get.dart';
import '../controllers/giveaway_campaign_controller.dart';

class GiveawayCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GiveawayCampaignController>(
          () => GiveawayCampaignController(),
    );
  }
}
