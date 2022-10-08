// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names, hash_and_equals, camel_case_types

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
  int reelCount;
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
    this.reelCount = 0,
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
      'noOfPosts': reelCount,
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
      referrer_id: map['referrer_id'] != null ? map['referrer_id'] as int : 0,
      is_deleted: map['is_deleted'] != null ? map['is_deleted'] as bool : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      updated_at:
          map['updated_at'] != null ? map['updated_at'] as String : null,
      user_profile: map['user_profile'] != null
          ? User_profile.fromMap(map['user_profile'] as Map<String, dynamic>)
          : null,
      reelCount: (map['reels_count'] ?? 0) as int,
      postsCount: (map['postsCount'] ?? 0) as int,
      followerCount: (map['followers_count'] ?? 0) as int,
      followingCount: (map['following_count'] ?? 0) as int,
      isFollowing:
          map['isFollowing'] != null ? map['isFollowing'] as bool : null,
    );
  }
  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(id: $id, email: $email, username: $username, status: $status, user_type: $user_type, referrer_id: $referrer_id, is_deleted: $is_deleted, created_at: $created_at, updated_at: $updated_at, user_profile: $user_profile, reelCount: $reelCount, postsCount: $postsCount, followerCount: $followerCount, followingCount: $followingCount, isFollowing: $isFollowing)';
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
        other.reelCount == reelCount &&
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
  final String? country;
  final String? state;
  User_profile({
    this.fullname = '',
    this.bio = '',
    this.profile_img = '',
    this.phone_pin = '',
    this.phone_number = '',
    this.current_language = '',
    this.country,
    this.state,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'bio': bio,
      'profile_img': profile_img,
      'phone_pin': phone_pin,
      'phone_number': phone_number,
      'current_language': current_language,
      'country': country,
      'state': state,
    };
  }

  factory User_profile.fromMap(Map<String, dynamic> map) {
    return User_profile(
      fullname: map['fullname'] != null ? map['fullname'] as String : '',
      bio: map['bio'] != null ? map['bio'] as String : '',
      profile_img:
          map['profile_img'] != null ? map['profile_img'] as String : '',
      phone_pin: map['phone_pin'] != null ? map['phone_pin'] as String : '',
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : '',
      current_language: map['current_language'] != null
          ? map['current_language'] as String
          : '',
      country: map['country'] != null ? map['country'] as String : '',
      state: map['state'] != null ? map['state'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User_profile.fromJson(String source) =>
      User_profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User_profile(fullname: $fullname, bio: $bio, profile_img: $profile_img, phone_pin: $phone_pin, phone_number: $phone_number, current_language: $current_language, country: $country, state: $state)';
  }

  @override
  bool operator ==(covariant User_profile other) {
    if (identical(this, other)) return true;

    return other.fullname == fullname &&
        other.bio == bio &&
        other.profile_img == profile_img &&
        other.phone_pin == phone_pin &&
        other.phone_number == phone_number &&
        other.current_language == current_language &&
        other.country == country &&
        other.state == state;
  }

  User_profile copyWith({
    String? fullname,
    String? bio,
    String? profile_img,
    String? phone_pin,
    String? phone_number,
    String? current_language,
    String? country,
    String? state,
  }) {
    return User_profile(
      fullname: fullname ?? this.fullname,
      bio: bio ?? this.bio,
      profile_img: profile_img ?? this.profile_img,
      phone_pin: phone_pin ?? this.phone_pin,
      phone_number: phone_number ?? this.phone_number,
      current_language: current_language ?? this.current_language,
      country: country ?? this.country,
      state: state ?? this.state,
    );
  }

  @override
  int get hashCode {
    return fullname.hashCode ^
        bio.hashCode ^
        profile_img.hashCode ^
        phone_pin.hashCode ^
        phone_number.hashCode ^
        current_language.hashCode ^
        country.hashCode ^
        state.hashCode;
  }
}
