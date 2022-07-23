import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:path/path.dart' as path;

class AddFeedController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _reelRepo = Get.find<ReelRepository>();

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;
  String? get userName => _authService.profileModel?.username;

  String title = "";
  String description = "";

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  void clean() {
    title = "";
    description = "";
  }

  // Future<int> uploadVideoOrPhoto(File file) async {
  //   try {
  //     final url = await _reelRepo.addPhotoOrVideo(file,token!);
  //     return url;
  //   } catch (e) {
  //     printInfo(info: "uploadVideoOrPhoto: $e");
  //     showSnackBar(e.toString(), color: Colors.red);
  //     return Future.error(e.toString());
  //   }
  // }

  void addFeed(File file, int type) async {
    loading = true;
    file = await changeFileNameOnly(file, 'video-$profileId!');
    final String _fileName =
        genFileName(profileId!.toString(), path.basename(file.path));
    var data = {
      "description": description,
      "filename": _fileName + path.extension(file.path),
      "media_ext": path.extension(file.path),
      "media_size": 65
    };
    print('2121 data $data');
    try {
      // final videoId = await _reelRepo.addPhotoOrVideo(file, token!);
      final s3File = await _reelRepo.uploadFileToAwsS3(
          userID: profileId!.toString(), file: file, fileName: _fileName);
      print('2121 s3File $s3File');
      await _reelRepo.addReel(data, token!);
      showSnackBar("Reel added successfully: $s3File");
      clean();
      Get.back();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("addFeed: $e");
    }
    loading = false;
  }

  /// This is used to generate a unique key for a file
  /// reels_nsharma_20220715_unique(uuid)_filename.mp4
  String genFileName(String userID, String fileName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    return 'reel_${userID}_${date}_${timestamp}_$fileName';
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
}
