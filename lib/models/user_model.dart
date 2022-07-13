import 'dart:convert';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String countryCode;
  final String mobileNumber;
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.countryCode,
    required this.mobileNumber,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? countryCode,
    String? mobileNumber,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'countryCode': countryCode,
      'mobileNumber': mobileNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      countryCode: map['countryCode'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, countryCode: $countryCode, mobileNumber: $mobileNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.username == username &&
      other.email == email &&
      other.countryCode == countryCode &&
      other.mobileNumber == mobileNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      countryCode.hashCode ^
      mobileNumber.hashCode;
  }
}

