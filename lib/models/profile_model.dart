import 'dart:convert';

class ProfileModel {
  final int id;
  final String fullname;
  final String bio;
  final String profileUrl;
  final int phoneNumber;
  final String username;
  final String email;
  final bool isVerified;
  final int noOfPosts;
  final int countryCode;
  ProfileModel({
    required this.id,
    required this.email,
    required this.fullname,
    required this.bio,
    required this.profileUrl,
    required this.phoneNumber,
    required this.username,
    required this.isVerified,
    required this.noOfPosts,
    required this.countryCode,
  });

  ProfileModel copyWith({
    int? id,
    String? fullname,
    String? bio,
    String? profileUrl,
    String? email,
    int? phoneNumber,
    String? username,
    bool? isVerified,
    int? noOfPosts,
    int? countryCode,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      bio: bio ?? this.bio,
      profileUrl: profileUrl ?? this.profileUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      isVerified: isVerified ?? this.isVerified,
      noOfPosts: noOfPosts ?? this.noOfPosts,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'bio': bio,
      'profileUrl': profileUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'username': username,
      'isVerified': isVerified,
      'noOfPosts': noOfPosts,
      'countryCode': countryCode,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toInt() ?? 0,
      fullname: map['fullname'] ?? '',
      bio: map['bio'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      email: map['user']['email'] ?? '',
      phoneNumber: int.parse(map['phoneNumber'] ?? "0"),
      username: map['username'] ?? '',
      isVerified: map['isVerified'] ?? false,
      noOfPosts: map['noOfPosts']?.toInt() ?? 0,
      countryCode: map['countryCode']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(id: $id, fullname: $fullname, bio: $bio, profileUrl: $profileUrl, email: $email, phoneNumber: $phoneNumber, username: $username, isVerified: $isVerified, noOfPosts: $noOfPosts, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.id == id &&
        other.fullname == fullname &&
        other.bio == bio &&
        other.profileUrl == profileUrl &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.username == username &&
        other.isVerified == isVerified &&
        other.noOfPosts == noOfPosts &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullname.hashCode ^
        bio.hashCode ^
        profileUrl.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        username.hashCode ^
        isVerified.hashCode ^
        noOfPosts.hashCode ^
        countryCode.hashCode;
  }
}
