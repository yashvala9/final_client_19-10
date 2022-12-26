// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BlockedusersModel {
  final String fullname;
  final String updated_at;

  final String profile_img;
  final String phone_number;
  final int user_id;

  final String bio;
  final String phone_pin;
  BlockedusersModel({
    required this.fullname,
    required this.updated_at,
    required this.profile_img,
    required this.phone_number,
    required this.user_id,
    required this.bio,
    required this.phone_pin,
  });

  BlockedusersModel copyWith({
    String? fullname,
    String? updated_at,
    String? profile_img,
    String? phone_number,
    int? user_id,
    String? bio,
    String? phone_pin,
  }) {
    return BlockedusersModel(
      fullname: fullname ?? this.fullname,
      updated_at: updated_at ?? this.updated_at,
      profile_img: profile_img ?? this.profile_img,
      phone_number: phone_number ?? this.phone_number,
      user_id: user_id ?? this.user_id,
      bio: bio ?? this.bio,
      phone_pin: phone_pin ?? this.phone_pin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'updated_at': updated_at,
      'profile_img': profile_img,
      'phone_number': phone_number,
      'user_id': user_id,
      'bio': bio,
      'phone_pin': phone_pin,
    };
  }

  factory BlockedusersModel.fromMap(Map<String, dynamic> map) {
    return BlockedusersModel(
      fullname: map['fullname'] as String,
      updated_at: map['updated_at'] as String,
      profile_img: map['profile_img'] as String,
      phone_number: map['phone_number'] as String,
      user_id: map['user_id'] as int,
      bio: map['bio'] as String,
      phone_pin: map['phone_pin'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedusersModel.fromJson(String source) =>
      BlockedusersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlockedusersModel(fullname: $fullname, updated_at: $updated_at, profile_img: $profile_img, phone_number: $phone_number, user_id: $user_id, bio: $bio, phone_pin: $phone_pin)';
  }

  @override
  bool operator ==(covariant BlockedusersModel other) {
    if (identical(this, other)) return true;

    return other.fullname == fullname &&
        other.updated_at == updated_at &&
        other.profile_img == profile_img &&
        other.phone_number == phone_number &&
        other.user_id == user_id &&
        other.bio == bio &&
        other.phone_pin == phone_pin;
  }

  @override
  int get hashCode {
    return fullname.hashCode ^
        updated_at.hashCode ^
        profile_img.hashCode ^
        phone_number.hashCode ^
        user_id.hashCode ^
        bio.hashCode ^
        phone_pin.hashCode;
  }
}
