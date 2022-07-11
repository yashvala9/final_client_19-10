import 'dart:convert';

class ProfileModel {
  final int id;
  final String fullname;
  final String bio;
  final String profileUrl;
  final int phoneNumber;
  final String username;
  final bool isVerified;
  bool? isFollowing;
  int noOfPosts;
  final int countryCode;
  int postsCount;
  int followerCount;
  int followingCount;
  ProfileModel({
    required this.id,
    required this.fullname,
    required this.bio,
    required this.profileUrl,
    required this.phoneNumber,
    required this.username,
    required this.isVerified,
    required this.noOfPosts,
    this.isFollowing,
    required this.countryCode,
    required this.postsCount,
    required this.followerCount,
    required this.followingCount,
  });

  ProfileModel copyWith({
    int? id,
    String? fullname,
    String? bio,
    String? profileUrl,
    int? phoneNumber,
    String? username,
    bool? isVerified,
    int? noOfPosts,
    int? countryCode,
    int? postsCount,
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      bio: bio ?? this.bio,
      profileUrl: profileUrl ?? this.profileUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      isVerified: isVerified ?? this.isVerified,
      noOfPosts: noOfPosts ?? this.noOfPosts,
      countryCode: countryCode ?? this.countryCode,
      postsCount: postsCount ?? this.postsCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'bio': bio,
      'profileUrl': profileUrl,
      'phoneNumber': phoneNumber,
      'username': username,
      'isVerified': isVerified,
      'noOfPosts': noOfPosts,
      'countryCode': countryCode,
      'postsCount': postsCount,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'isFollowing': isFollowing,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toInt() ?? 0,
      fullname: map['fullname'] ?? '',
      bio: map['bio'] ?? '',
      isFollowing: map['isFollowing'] ,
      profileUrl: map['profileUrl'] ?? '',
      phoneNumber: int.parse(map['phoneNumber'] ?? '0'),
      username: map['username'] ?? '',
      isVerified: map['isVerified'] ?? false,
      noOfPosts: map['noOfPosts']?.toInt() ?? 0,
      countryCode: map['countryCode']?.toInt() ?? 0,
      postsCount: map['postsCount']?.toInt() ?? 0,
      followerCount: map['followerCount']?.toInt() ?? 0,
      followingCount: map['followingCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(id: $id, fullname: $fullname, bio: $bio, profileUrl: $profileUrl, phoneNumber: $phoneNumber, username: $username, isVerified: $isVerified, noOfPosts: $noOfPosts, countryCode: $countryCode, postsCount: $postsCount, followerCount: $followerCount, followingCount: $followingCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.id == id &&
        other.fullname == fullname &&
        other.bio == bio &&
        other.profileUrl == profileUrl &&
        other.phoneNumber == phoneNumber &&
        other.username == username &&
        other.isVerified == isVerified &&
        other.noOfPosts == noOfPosts &&
        other.countryCode == countryCode &&
        other.postsCount == postsCount &&
        other.followerCount == followerCount &&
        other.followingCount == followingCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullname.hashCode ^
        bio.hashCode ^
        profileUrl.hashCode ^
        phoneNumber.hashCode ^
        username.hashCode ^
        isVerified.hashCode ^
        noOfPosts.hashCode ^
        countryCode.hashCode ^
        postsCount.hashCode ^
        followerCount.hashCode ^
        followingCount.hashCode;
  }
}
