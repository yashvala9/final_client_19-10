// To parse this JSON data, do
//
//     final reel = photoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<PhotoModel> photoFromJson(String str) =>
    List<PhotoModel>.from(json.decode(str).map((x) => PhotoModel.fromJson(x)));

String photoToJson(List<PhotoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhotoModel {
  PhotoModel({
    required this.id,
    required this.description,
    required this.mediaLink,
    required this.mediaType,
    required this.mediaExt,
    required this.isDeleted,
    required this.profile,
    required this.title,
    required this.type,
    required this.song,
    required this.reelId,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.videoId,
    required this.reelComments,
    required this.hashtags,
    required this.isLiked,
  });

  int id;
  String description;
  dynamic mediaLink;
  dynamic mediaType;
  dynamic mediaExt;
  dynamic isDeleted;
  Profile profile;
  String title;
  bool type;
  String song;
  String reelId;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int likeCount;
  int commentCount;
  VideoId videoId;
  List<dynamic> reelComments;
  List<dynamic> hashtags;
  bool isLiked;

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        id: json["id"],
        description: json["description"],
        mediaLink: json["mediaLink"],
        mediaType: json["mediaType"],
        mediaExt: json["mediaExt"],
        isDeleted: json["isDeleted"],
        profile: Profile.fromJson(json["profile"]),
        title: json["title"],
        type: json["type"],
        song: json["song"],
        reelId: json["reelId"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        likeCount: json["likeCount"],
        commentCount: json["commentCount"],
        videoId: VideoId.fromJson(json["videoId"]),
        reelComments: List<dynamic>.from(json["reel_comments"].map((x) => x)),
        hashtags: List<dynamic>.from(json["hashtags"].map((x) => x)),
        isLiked: json["isLiked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "mediaLink": mediaLink,
        "mediaType": mediaType,
        "mediaExt": mediaExt,
        "isDeleted": isDeleted,
        "profile": profile.toJson(),
        "title": title,
        "type": type,
        "song": song,
        "reelId": reelId,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "likeCount": likeCount,
        "commentCount": commentCount,
        "videoId": videoId.toJson(),
        "reel_comments": List<dynamic>.from(reelComments.map((x) => x)),
        "hashtags": List<dynamic>.from(hashtags.map((x) => x)),
        "isLiked": isLiked,
      };
}

class Profile {
  Profile({
    required this.id,
    required this.fullname,
    required this.bio,
    required this.phonePin,
    required this.phoneNumber,
    required this.currentLanguage,
    required this.address,
    required this.city,
    required this.pincode,
    required this.country,
    required this.isDeleted,
    required this.user,
    required this.username,
    required this.isVerified,
    required this.noOfPosts,
    required this.profileUrl,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.countryCode,
    required this.postsCount,
    required this.followerCount,
    required this.followingCount,
    required this.profileImg,
  });

  int id;
  String fullname;
  String bio;
  int phonePin;
  String phoneNumber;
  String currentLanguage;
  dynamic address;
  dynamic city;
  dynamic pincode;
  dynamic country;
  dynamic isDeleted;
  int user;
  String username;
  bool isVerified;
  dynamic noOfPosts;
  dynamic profileUrl;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int countryCode;
  int postsCount;
  int followerCount;
  int followingCount;
  dynamic profileImg;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        fullname: json["fullname"],
        bio: json["bio"],
        phonePin: json["phonePin"],
        phoneNumber: json["phoneNumber"],
        currentLanguage: json["currentLanguage"],
        address: json["address"],
        city: json["city"],
        pincode: json["pincode"],
        country: json["country"],
        isDeleted: json["isDeleted"],
        user: json["user"],
        username: json["username"],
        isVerified: json["isVerified"],
        noOfPosts: json["noOfPosts"],
        profileUrl: json["profileUrl"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        countryCode: json["countryCode"],
        postsCount: json["postsCount"],
        followerCount: json["followerCount"],
        followingCount: json["followingCount"],
        profileImg: json["profileImg"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "bio": bio,
        "phonePin": phonePin,
        "phoneNumber": phoneNumber,
        "currentLanguage": currentLanguage,
        "address": address,
        "city": city,
        "pincode": pincode,
        "country": country,
        "isDeleted": isDeleted,
        "user": user,
        "username": username,
        "isVerified": isVerified,
        "noOfPosts": noOfPosts,
        "profileUrl": profileUrl,
        "published_at": publishedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "countryCode": countryCode,
        "postsCount": postsCount,
        "followerCount": followerCount,
        "followingCount": followingCount,
        "profileImg": profileImg,
      };
}

class VideoId {
  VideoId({
    required this.id,
    required this.name,
    required this.alternativeText,
    required this.caption,
    required this.width,
    required this.height,
    required this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    required this.previewUrl,
    required this.provider,
    required this.providerMetadata,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  dynamic alternativeText;
  dynamic caption;
  int width;
  int height;
  Formats formats;
  String hash;
  String ext;
  String mime;
  double size;
  String url;
  dynamic previewUrl;
  String provider;
  dynamic providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory VideoId.fromJson(Map<String, dynamic> json) => VideoId(
        id: json["id"],
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: Formats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: json["ext"],
        mime: json["mime"],
        size: json["size"].toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: json["provider"],
        providerMetadata: json["provider_metadata"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": formats.toJson(),
        "hash": hash,
        "ext": ext,
        "mime": mime,
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": provider,
        "provider_metadata": providerMetadata,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Formats {
  Formats({
    required this.large,
    required this.small,
    required this.medium,
    required this.thumbnail,
  });

  Large large;
  Large small;
  Large medium;
  Large thumbnail;

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        large: Large.fromJson(json["large"]),
        small: Large.fromJson(json["small"]),
        medium: Large.fromJson(json["medium"]),
        thumbnail: Large.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "large": large.toJson(),
        "small": small.toJson(),
        "medium": medium.toJson(),
        "thumbnail": thumbnail.toJson(),
      };
}

class Large {
  Large({
    required this.ext,
    required this.url,
    required this.hash,
    required this.mime,
    required this.name,
    required this.path,
    required this.size,
    required this.width,
    required this.height,
  });

  String ext;
  String url;
  String hash;
  String mime;
  String name;
  dynamic path;
  double size;
  int width;
  int height;

  factory Large.fromJson(Map<String, dynamic> json) => Large(
        ext: json["ext"],
        url: json["url"],
        hash: json["hash"],
        mime: json["mime"],
        name: json["name"],
        path: json["path"],
        size: json["size"].toDouble(),
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "ext": ext,
        "url": url,
        "hash": hash,
        "mime": mime,
        "name": name,
        "path": path,
        "size": size,
        "width": width,
        "height": height,
      };
}
