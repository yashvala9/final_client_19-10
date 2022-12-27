import 'dart:convert';

class WinnerModel {
  final int id;
  final String userName;
  final String userImage;
  final String contestName;
  final String status;
  final String prizeName;
  final String prizeImage;
  final String email;
  final String phone;
  final String image;
  WinnerModel({
    this.id = 0,
    this.userName = '',
    this.userImage = '',
    this.contestName = '',
    this.status = '',
    this.prizeName = '',
    this.prizeImage = '',
    this.email = '',
    this.phone = '',
    required this.image,
  });

  WinnerModel copyWith({
    int? id,
    String? userName,
    String? userImage,
    String? contestName,
    String? status,
    String? prizeName,
    String? prizeImage,
    String? email,
    String? phone,
    String? image,
  }) {
    return WinnerModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      contestName: contestName ?? this.contestName,
      status: status ?? this.status,
      prizeName: prizeName ?? this.prizeName,
      prizeImage: prizeImage ?? this.prizeImage,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'userImage': userImage,
      'contestName': contestName,
      'status': status,
      'prizeName': prizeName,
      'prizeImage': prizeImage,
      'email': email,
      'phone': phone,
      'image': image,
    };
  }

  factory WinnerModel.fromMap(Map<String, dynamic> map) {
    return WinnerModel(
      id: map['id'] as int,
      userName: map['user']['fullname'] ?? '',
      userImage: map['user']['profile_img'] ?? '',
      contestName: map['contest']['contest_name'] ?? '',
      status: map['status'] ?? '',
      prizeName: 'Static',
      prizeImage: 'static',
      email: map['user']['email'] ?? '',
      image: map['image'] ?? '',
      phone: (map['user']['pincode'] ?? '') + map['user']['phone_number'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WinnerModel.fromJson(String source) =>
      WinnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WinnerModel(id: $id, userName: $userName, userImage: $userImage, contestName: $contestName, status: $status, prizeName: $prizeName, prizeImage: $prizeImage, email: $email, phone: $phone, image: $image)';
  }

  @override
  bool operator ==(covariant WinnerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.userImage == userImage &&
        other.contestName == contestName &&
        other.status == status &&
        other.prizeName == prizeName &&
        other.prizeImage == prizeImage &&
        other.email == email &&
        other.phone == phone &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        userImage.hashCode ^
        contestName.hashCode ^
        status.hashCode ^
        prizeName.hashCode ^
        prizeImage.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        image.hashCode;
  }
}
