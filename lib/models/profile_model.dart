// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class ProfileModel {
  final int id;
  final String? email;
  final String? username;
  final String? status;
  final String? user_type;
  final int? referrer_id;
  final bool? is_deleted;
  final String? created_at;
  final String? updated_at;
  final User_profile? user_profile;
  int noOfPosts;
  int postsCount;
  int followerCount;
  int followingCount;
  bool? isFollowing;
  ProfileModel({
    this.id = 0,
    this.email = '',
    this.username = '',
    this.status = '',
    this.user_type,
    this.referrer_id,
    this.is_deleted,
    this.created_at,
    this.updated_at,
    this.user_profile,
    this.noOfPosts = 0,
    this.postsCount = 0,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'status': status,
      'user_type': user_type,
      'referrer_id': referrer_id,
      'is_deleted': is_deleted,
      'created_at': created_at,
      'updated_at': updated_at,
      'user_profile': user_profile?.toMap(),
      'noOfPosts': noOfPosts,
      'postsCount': postsCount,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'isFollowing': isFollowing,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: (map['id'] ?? 0) as int,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      user_type: map['user_type'] != null ? map['user_type'] as String : null,
      referrer_id:
          map['referrer_id'] != null ? map['referrer_id'] as int : null,
      is_deleted: map['is_deleted'] != null ? map['is_deleted'] as bool : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      updated_at:
          map['updated_at'] != null ? map['updated_at'] as String : null,
      user_profile: map['user_profile'] != null
          ? User_profile.fromMap(map['user_profile'] as Map<String, dynamic>)
          : null,
      noOfPosts: (map['noOfPosts'] ?? 0) as int,
      postsCount: (map['postsCount'] ?? 0) as int,
      followerCount: (map['followerCount'] ?? 0) as int,
      followingCount: (map['followingCount'] ?? 0) as int,
      isFollowing:
          map['isFollowing'] != null ? map['isFollowing'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(id: $id, email: $email, username: $username, status: $status, user_type: $user_type, referrer_id: $referrer_id, is_deleted: $is_deleted, created_at: $created_at, updated_at: $updated_at, user_profile: $user_profile, noOfPosts: $noOfPosts, postsCount: $postsCount, followerCount: $followerCount, followingCount: $followingCount, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;
  
    return other.id == id &&
        other.email == email &&
        other.username == username &&
        other.status == status &&
        other.user_type == user_type &&
        other.referrer_id == referrer_id &&
        other.is_deleted == is_deleted &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.user_profile == user_profile &&
        other.noOfPosts == noOfPosts &&
        other.postsCount == postsCount &&
        other.followerCount == followerCount &&
        other.followingCount == followingCount &&
        other.isFollowing == isFollowing;
  }
}

class User_profile {
  final String? fullname;
  final String? bio;
  final String? profile_img;
  final String? phone_pin;
  final String? phone_number;
  final String? current_language;
  User_profile({
    this.fullname = '',
    this.bio = '',
    this.profile_img = '',
    this.phone_pin = '',
    this.phone_number = '',
    this.current_language = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'bio': bio,
      'profile_img': profile_img,
      'phone_pin': phone_pin,
      'phone_number': phone_number,
      'current_language': current_language,
    };
  }

  factory User_profile.fromMap(Map<String, dynamic> map) {
    return User_profile(
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      profile_img:
          map['profile_img'] != null ? map['profile_img'] as String : null,
      phone_pin: map['phone_pin'] != null ? map['phone_pin'] as String : null,
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : null,
      current_language: map['current_language'] != null
          ? map['current_language'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User_profile.fromJson(String source) =>
      User_profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User_profile(fullname: $fullname, bio: $bio, profile_img: $profile_img, phone_pin: $phone_pin, phone_number: $phone_number, current_language: $current_language)';
  }

  @override
  bool operator ==(covariant User_profile other) {
    if (identical(this, other)) return true;

    return other.fullname == fullname &&
        other.bio == bio &&
        other.profile_img == profile_img &&
        other.phone_pin == phone_pin &&
        other.phone_number == phone_number &&
        other.current_language == current_language;
  }
}
