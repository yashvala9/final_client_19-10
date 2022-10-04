import 'dart:developer';
import 'dart:io';

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

  void addFeed(File file, int type) async {
    if (type == 1) {
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
          await _reelRepo.addPhoto(data, token!);

          ProfileRepository().uploadProfileToAwsS3(
              file: file, fileName: _fileName, userID: profileId!.toString());
          showSnackBar("Photo added successfully!");

          clean();
          Get.back(result: true);
          Get.back(result: true);
        } catch (e) {
          log("addFeed: $e");
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
        await _reelRepo.addReel(data, token!);

        await _reelRepo.uploadFileToAwsS3(
            userID: profileId!.toString(), file: file, fileName: _fileName);

        await _reelRepo.updateStatus(_fileName, "UPLOADED", token!);
        showSnackBar("Reel added successfully!");
        clean();
        Get.back(result: true);
        Get.back(result: true);
      } catch (e) {
        log("addFeed: $e");
      }
      loading = false;
    }
  }

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
