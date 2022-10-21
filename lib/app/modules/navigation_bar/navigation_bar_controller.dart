import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reel_ro/app/modules/add_feed/widgets/video_trimmer_view.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';

import '../../../utils/video_player_item.dart';
import '../single_feed/single_feed_screen.dart';

class NavigationBarController extends GetxController {
  var tabIndex = 0.obs;

  final _reelRepo = Get.put(ReelRepository());
  final _authService = Get.isRegistered<AuthService>()
      ? Get.find<AuthService>()
      : Get.put(AuthService());
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      var initialLink = await dynamicLinks.getInitialLink();
      if (initialLink != null) {
        var deepLink = initialLink.link;
        if (deepLink != null) {
          _handleDynamicLink(initialLink);
        } else {
          log("deep link is not working");
        }
      } else {
        log("InitialLInk is null");
      }

      dynamicLinks.onLink.listen((event) async {
        _handleDynamicLink(event);
        // Get.to(() => Demo());
        // if (type == 'reels') {
        //   var reel = await _reelRepo.getSingleReel(id, _authService.token!);
        //   Get.to(() => SingleFeedScreen(null, [reel], 0, isPhoto: false));
        // } else {
        //   var photo = await _reelRepo.getPhotosById(id, _authService.token!);
        //   Get.to(() => SingleFeedScreen([photo], null, 0, isPhoto: true));
        // }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handleDynamicLink(PendingDynamicLinkData dLlink) async {
    log("event:: $dLlink");
    log("event link path:: ${dLlink.link.path}");
    var idAndType = dLlink.link.toString().split("=").last;
    var id = idAndType.split('/').first;
    var type = idAndType.split('/').last;
    log("ReelID:: $id");
    log("Type:: $type");
    if (type == 'reels') {
      var reel = await _reelRepo.getSingleReel(id, _authService.token!);
      Get.to(() => SingleFeedScreen(null, [reel], 0, isPhoto: false));
    } else {
      log("Navigate Photo");
      var photo = await _reelRepo.getPhotosById(id, _authService.token!);
      Get.to(() => SingleFeedScreen([photo], null, 0, isPhoto: true));
    }
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
