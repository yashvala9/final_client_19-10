import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../main.dart';
import '../utils/base.dart';

class CommunicationService extends GetxService {
  static CommunicationService get to => Get.find<CommunicationService>();

  final _authService = Get.isRegistered<AuthService>()
      ? Get.find<AuthService>()
      : Get.put(AuthService());

  final StreamChatClient _streamChatClient = kDefaultStreamChatClient;
  StreamChatClient get client => _streamChatClient;

  final GetStorage _storage = GetStorage();
  final Rxn<User> currentUser = Rxn<User>();
  final RxInt totalUnreadChannelsCount = RxInt(0);
  final RxInt totalUnreadMessagesCount = RxInt(0);

  void saveStreamAccessToken(String token) =>
      _storage.write('streamToken', token);

  String? get readStreamAccessToken => _storage.read<String?>('streamToken');

  void get initClient => _init();

  void _init() async {
    if (_authService.isAuthenticated) {
      authenticateUser(_authService.profileModel!);
    }
  }

  void authenticateUser(
    ProfileModel profileModel,
  ) async {
    log("Authenticated Profile: $profileModel");
    if (profileModel.user_profile != null) {
      log("CreatingUser.....");
      User _user = User(
        id: profileModel.id.toString(),
        name: profileModel.user_profile!.fullname,
        image: profileModel.user_profile?.profile_img ?? Assets.profile,
        extraData: {
          'refId': profileModel.id.toString(),
          'fullName': profileModel.user_profile!.fullname,
          'profilePic': profileModel.user_profile?.profile_img == null
              ? ""
              : "${Base.profileBucketUrl}/${profileModel.user_profile!.profile_img}",
        },
        online: true,
        updatedAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      currentUser(_user);
      if (readStreamAccessToken != null) {
        log("ConnectingUser....");
        client.connectUser(_user, readStreamAccessToken!);
        _streamChatClient.sync();
      }
    } else {
      if (kDebugMode) {
        Get.log('Stream ChatClient not able to connect');
      }
    }
  }

  Future<void> disconnectClient() async => _streamChatClient.disconnectUser();
}
