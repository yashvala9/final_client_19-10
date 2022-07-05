import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../models/comment.dart';
import '../../../models/video.dart';

class HomePageController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([
    Video(
      username: "yashvala9",
      uid: "uid",
      id: "1",
      likes: [],
      commentCount: 123,
      shareCount: 456,
      songName: "songName",
      caption: "caption",
      videoUrl:
          "https://firebasestorage.googleapis.com/v0/b/ticktok-demo.appspot.com/o/videos%2FVideo%203?alt=media&token=fe645364-ac1e-4c96-a2f2-04ee9dcb99d4",
      profilePhoto:
          "https://firebasestorage.googleapis.com/v0/b/ticktok-demo.appspot.com/o/profilePics%2FS9FpK7hTIVbU6YzTt8zBBgyFdty2?alt=media&token=6a9aa08d-60f8-4003-994c-12350737ab5a",
      thumbnail:
          "https://firebasestorage.googleapis.com/v0/b/ticktok-demo.appspot.com/o/thumbnails%2FVideo%200?alt=media&token=edd77dcc-15a7-4809-97b6-649e093f4326",
    ),
    Video(
      username: "yashvala9",
      uid: "uid",
      id: "2",
      likes: [],
      commentCount: 123,
      shareCount: 456,
      songName: "songName",
      caption: "caption",
      videoUrl:
          "https://firebasestorage.googleapis.com/v0/b/ticktok-demo.appspot.com/o/videos%2FVideo%200?alt=media&token=36e96aac-25ae-482c-80d8-e849e56284c8",
      profilePhoto:
          "https://firebasestorage.googleapis.com/v0/b/ticktok-demo.appspot.com/o/profilePics%2FS9FpK7hTIVbU6YzTt8zBBgyFdty2?alt=media&token=6a9aa08d-60f8-4003-994c-12350737ab5a",
      thumbnail:
          "https://firebasestorage.googleapis.com/v0/b/ticktok-demo.appspot.com/o/thumbnails%2FVideo%200?alt=media&token=edd77dcc-15a7-4809-97b6-649e093f4326",
    ),
  ]);
  List<Video> get videoList => _videoList.value;

  final Rx<List<Comment>> _comments = Rx<List<Comment>>([
    Comment(
        username: "yashvala9",
        comment: "comment",
        datePublished: "datePublished",
        likes: [],
        profilePhoto: "profilePhoto",
        uid: "1",
        id: "1")
  ]);
  List<Comment> get comments => _comments.value;

  @override
  void onInit() {
    super.onInit();
  }
}
