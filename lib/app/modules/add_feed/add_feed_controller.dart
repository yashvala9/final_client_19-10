import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
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
  List<String?> tags = [];

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
    if (type == 1) {
      //photo type
      {
        List<String> splitted = description.split(" ");
        for (var item in splitted) {
          if (item.startsWith("#")) {
            tags.add(item);
          }
        }
        loading = true;
        log("File: $file");
        file = await changeFileNameOnly(file, 'photo-$profileId');
        final String _fileName =
            genFileName(profileId!.toString(), path.basename(file.path));
        var data = {
          "title": title,
          "content": description,
          "filename": _fileName,
          "published": true,
          "hashtags": tags
        };
        try {
          //step 1: make entry in DB
          await _reelRepo.addPhoto(data, token!);
          //step 2: upload file to s3
          ProfileRepository().uploadProfileToAwsS3(
              file: file, fileName: _fileName, userID: profileId!.toString());
          showSnackBar("Photo added successfully!");

          clean();
          Get.back(result: true);
          Get.back(result: true);
        } catch (e) {
          showSnackBar(e.toString(), color: Colors.red);
        }
        loading = false;
      }
    } else {
      List<String> splitted = description.split(" ");
      for (var item in splitted) {
        if (item.startsWith("#")) {
          tags.add(item);
        }
      }
      loading = true;
      log("File: $file");
      file = await changeFileNameOnly(file, 'video-$profileId');
      final String _fileName =
          genFileName(profileId!.toString(), path.basename(file.path));
      var data = {
        "description": description,
        "filename": _fileName,
        "media_ext": path.extension(file.path).replaceAll('.', ''),
        "media_size": 65,
        "hashtags": tags
      };
      try {
        //step 1: make entry in DB
        await _reelRepo.addReel(data, token!);
        //step 2: upload file to s3
        await _reelRepo.uploadFileToAwsS3(
            userID: profileId!.toString(), file: file, fileName: _fileName);
        //step 3: make entry of upload status in db
        await _reelRepo.updateStatus(_fileName, "UPLOADED", token!);
        showSnackBar("Reel added successfully!");
        clean();
        Get.back(result: true);
        Get.back(result: true);
      } catch (e) {
        showSnackBar(e.toString(), color: Colors.red);
      }
      loading = false;
    }
  }

  /// This is used to generate a unique key for a file
  /// reels_nsharma_20220715_unique(uuid)_filename.mp4
  String genFileName(String userID, String fileName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final date = DateFormat('yyyyMMdd').format(DateTime.now().toUtc());
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
