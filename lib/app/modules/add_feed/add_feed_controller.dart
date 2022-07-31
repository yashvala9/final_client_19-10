import 'dart:developer';
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
    log("File: $file");
    file = await changeFileNameOnly(file, 'video-$profileId');
    final String _fileName =
        genFileName(profileId!.toString(), path.basename(file.path));
    var data = {
      "description": description,
      "filename": _fileName,
      "media_ext": path.extension(file.path).replaceAll('.', ''),
      "media_size": 65
    };
    print('2121 data $data');
    try {
      //step 1: make entry in DB
      await _reelRepo.addReel(data, token!);
      //step 2: upload file to s3
      final s3File = await _reelRepo.uploadFileToAwsS3(
          userID: profileId!.toString(), file: file, fileName: _fileName);
      print('2121 s3File ${s3File ?? ''}');
      //step 3: make entry of upload status in db
      await _reelRepo.updateStatus(_fileName, "UPLOADED", token!);
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
    var filepath = file.path;
    var lastSeparator = filepath.lastIndexOf(Platform.pathSeparator);
    var extension = path.extension(file.path).toString();
    var newPath =
        filepath.substring(0, lastSeparator + 1) + newFileName + extension;
    return file.rename(newPath);
  }
}
