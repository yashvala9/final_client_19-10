// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ContestModel {
  final String? contest_name;
  final String? creator_type;
  final int? creator_id;
  final String? start_date;
  final String? end_date;
  final String? rules;
  final int? prize_count;
  final int? id;
  final List<Prize> prizes;
  final List<Winner> winners;
  final String? created_at;
  final String? updated_at;
  ContestModel({
    required this.contest_name,
    required this.creator_type,
    required this.creator_id,
    required this.start_date,
    required this.end_date,
    required this.rules,
    required this.prize_count,
    required this.id,
    required this.prizes,
    required this.winners,
    required this.created_at,
    required this.updated_at,
  });

  ContestModel copyWith({
    String? contest_name,
    String? creator_type,
    int? creator_id,
    String? start_date,
    String? end_date,
    String? rules,
    int? prize_count,
    int? id,
    List<Prize>? prizes,
    List<Winner>? winners,
    String? created_at,
    String? updated_at,
  }) {
    return ContestModel(
      contest_name: contest_name ?? this.contest_name,
      creator_type: creator_type ?? this.creator_type,
      creator_id: creator_id ?? this.creator_id,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      rules: rules ?? this.rules,
      prize_count: prize_count ?? this.prize_count,
      id: id ?? this.id,
      prizes: prizes ?? this.prizes,
      winners: winners ?? this.winners,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contest_name': contest_name,
      'creator_type': creator_type,
      'creator_id': creator_id,
      'start_date': start_date,
      'end_date': end_date,
      'rules': rules,
      'prize_count': prize_count,
      'id': id,
      'prizes': prizes.map((x) => x.toMap()).toList(),
      'winners': winners.map((x) => x.toMap()).toList(),
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory ContestModel.fromMap(Map<String, dynamic> map) {
    return ContestModel(
      contest_name:
          map['contest_name'] != null ? map['contest_name'] as String : null,
      creator_type:
          map['creator_type'] != null ? map['creator_type'] as String : null,
      creator_id: map['creator_id'] != null ? map['creator_id'] as int : null,
      start_date:
          map['start_date'] != null ? map['start_date'] as String : null,
      end_date: map['end_date'] != null ? map['end_date'] as String : null,
      rules: map['rules'] != null ? map['rules'] as String : null,
      prize_count:
          map['prize_count'] != null ? map['prize_count'] as int : null,
      id: map['id'] != null ? map['id'] as int : null,
      prizes: List<Prize>.from(
        (map['prizes']).map<Prize>(
          (x) => Prize.fromMap(x as Map<String, dynamic>),
        ),
      ),
      winners: List<Winner>.from(
        (map['winners']).map<Winner>(
          (x) => Winner.fromMap(x as Map<String, dynamic>),
        ),
      ),
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      updated_at:
          map['updated_at'] != null ? map['updated_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContestModel.fromJson(String source) =>
      ContestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContestModel(contest_name: $contest_name, creator_type: $creator_type, creator_id: $creator_id, start_date: $start_date, end_date: $end_date, rules: $rules, prize_count: $prize_count, id: $id, prizes: $prizes, winners: $winners, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant ContestModel other) {
    if (identical(this, other)) return true;

    return other.contest_name == contest_name &&
        other.creator_type == creator_type &&
        other.creator_id == creator_id &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.rules == rules &&
        other.prize_count == prize_count &&
        other.id == id &&
        listEquals(other.prizes, prizes) &&
        listEquals(other.winners, winners) &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return contest_name.hashCode ^
        creator_type.hashCode ^
        creator_id.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        rules.hashCode ^
        prize_count.hashCode ^
        id.hashCode ^
        prizes.hashCode ^
        winners.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}

class Prize {
  final int? id;
  final int? contest_id;
  final String? prize_name;
  final String? prize_image;
  final String? prize_description;
  Prize({
    required this.id,
    required this.contest_id,
    required this.prize_name,
    required this.prize_image,
    required this.prize_description,
  });

  Prize copyWith({
    int? id,
    int? contest_id,
    String? prize_name,
    String? prize_image,
    String? prize_description,
  }) {
    return Prize(
      id: id ?? this.id,
      contest_id: contest_id ?? this.contest_id,
      prize_name: prize_name ?? this.prize_name,
      prize_image: prize_image ?? this.prize_image,
      prize_description: prize_description ?? this.prize_description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contest_id': contest_id,
      'prize_name': prize_name,
      'prize_image': prize_image,
      'prize_description': prize_description,
    };
  }

  factory Prize.fromMap(Map<String, dynamic> map) {
    return Prize(
      id: map['id'] != null ? map['id'] as int : null,
      contest_id: map['contest_id'] != null ? map['contest_id'] as int : null,
      prize_name:
          map['prize_name'] != null ? map['prize_name'] as String : null,
      prize_image:
          map['prize_image'] != null ? map['prize_image'] as String : null,
      prize_description: map['prize_description'] != null
          ? map['prize_description'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Prize.fromJson(String source) =>
      Prize.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Prize(id: $id, contest_id: $contest_id, prize_name: $prize_name, prize_image: $prize_image, prize_description: $prize_description)';
  }

  @override
  bool operator ==(covariant Prize other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.contest_id == contest_id &&
        other.prize_name == prize_name &&
        other.prize_image == prize_image &&
        other.prize_description == prize_description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contest_id.hashCode ^
        prize_name.hashCode ^
        prize_image.hashCode ^
        prize_description.hashCode;
  }
}

class Winner {
  final int? id;
  final int? user_id;
  final User user;
  final String? created_at;
  final String? updated_at;
  final String? status;
  Winner({
    required this.id,
    required this.user_id,
    required this.user,
    required this.created_at,
    required this.updated_at,
    required this.status,
  });

  Winner copyWith({
    int? id,
    int? user_id,
    User? user,
    String? created_at,
    String? updated_at,
    String? status,
  }) {
    return Winner(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      user: user ?? this.user,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'user': user.toMap(),
      'created_at': created_at,
      'updated_at': updated_at,
      'status': status,
    };
  }

  factory Winner.fromMap(Map<String, dynamic> map) {
    return Winner(
      id: map['id'] != null ? map['id'] as int : null,
      user_id: map['user_id'] != null ? map['user_id'] as int : null,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      updated_at:
          map['updated_at'] != null ? map['updated_at'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Winner.fromJson(String source) =>
      Winner.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Winner(id: $id, user_id: $user_id, user: $user, created_at: $created_at, updated_at: $updated_at, status: $status)';
  }

  @override
  bool operator ==(covariant Winner other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.user == user &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        user.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        status.hashCode;
  }
}

class User {
  final int? id;
  final String? email;
  final String? username;
  final String? status;
  final String? user_type;
  final User_profile user_profile;
  final int? referrer_id;
  final String? created_at;
  final String? updated_at;
  final bool? is_blocked;
  final bool? is_suspended;
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.status,
    required this.user_type,
    required this.user_profile,
    required this.referrer_id,
    required this.created_at,
    required this.updated_at,
    required this.is_blocked,
    required this.is_suspended,
  });

  User copyWith({
    int? id,
    String? email,
    String? username,
    String? status,
    String? user_type,
    User_profile? user_profile,
    int? referrer_id,
    String? created_at,
    String? updated_at,
    bool? is_blocked,
    bool? is_suspended,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      status: status ?? this.status,
      user_type: user_type ?? this.user_type,
      user_profile: user_profile ?? this.user_profile,
      referrer_id: referrer_id ?? this.referrer_id,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_blocked: is_blocked ?? this.is_blocked,
      is_suspended: is_suspended ?? this.is_suspended,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'status': status,
      'user_type': user_type,
      'user_profile': user_profile.toMap(),
      'referrer_id': referrer_id,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_blocked': is_blocked,
      'is_suspended': is_suspended,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      user_type: map['user_type'] != null ? map['user_type'] as String : null,
      user_profile:
          User_profile.fromMap(map['user_profile'] as Map<String, dynamic>),
      referrer_id:
          map['referrer_id'] != null ? map['referrer_id'] as int : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      updated_at:
          map['updated_at'] != null ? map['updated_at'] as String : null,
      is_blocked: map['is_blocked'] != null ? map['is_blocked'] as bool : null,
      is_suspended:
          map['is_suspended'] != null ? map['is_suspended'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, status: $status, user_type: $user_type, user_profile: $user_profile, referrer_id: $referrer_id, created_at: $created_at, updated_at: $updated_at, is_blocked: $is_blocked, is_suspended: $is_suspended)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.username == username &&
        other.status == status &&
        other.user_type == user_type &&
        other.user_profile == user_profile &&
        other.referrer_id == referrer_id &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.is_blocked == is_blocked &&
        other.is_suspended == is_suspended;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        status.hashCode ^
        user_type.hashCode ^
        user_profile.hashCode ^
        referrer_id.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        is_blocked.hashCode ^
        is_suspended.hashCode;
  }
}

class User_profile {
  final String? fullname;
  final String? bio;
  final String? profile_img;
  final String? phone_pin;
  final String? phone_number;
  final String? current_language;
  final String? address;
  final String? city;
  final String? pincode;
  final String? country;
  final String? state;
  final String? category;
  User_profile({
    required this.fullname,
    required this.bio,
    required this.profile_img,
    required this.phone_pin,
    required this.phone_number,
    required this.current_language,
    required this.address,
    required this.city,
    required this.pincode,
    required this.country,
    required this.state,
    required this.category,
  });

  User_profile copyWith({
    String? fullname,
    String? bio,
    String? profile_img,
    String? phone_pin,
    String? phone_number,
    String? current_language,
    String? address,
    String? city,
    String? pincode,
    String? country,
    String? state,
    String? category,
  }) {
    return User_profile(
      fullname: fullname ?? this.fullname,
      bio: bio ?? this.bio,
      profile_img: profile_img ?? this.profile_img,
      phone_pin: phone_pin ?? this.phone_pin,
      phone_number: phone_number ?? this.phone_number,
      current_language: current_language ?? this.current_language,
      address: address ?? this.address,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      country: country ?? this.country,
      state: state ?? this.state,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'bio': bio,
      'profile_img': profile_img,
      'phone_pin': phone_pin,
      'phone_number': phone_number,
      'current_language': current_language,
      'address': address,
      'city': city,
      'pincode': pincode,
      'country': country,
      'state': state,
      'category': category,
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
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User_profile.fromJson(String source) =>
      User_profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User_profile(fullname: $fullname, bio: $bio, profile_img: $profile_img, phone_pin: $phone_pin, phone_number: $phone_number, current_language: $current_language, address: $address, city: $city, pincode: $pincode, country: $country, state: $state, category: $category)';
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
        other.address == address &&
        other.city == city &&
        other.pincode == pincode &&
        other.country == country &&
        other.state == state &&
        other.category == category;
  }

  @override
  int get hashCode {
    return fullname.hashCode ^
        bio.hashCode ^
        profile_img.hashCode ^
        phone_pin.hashCode ^
        phone_number.hashCode ^
        current_language.hashCode ^
        address.hashCode ^
        city.hashCode ^
        pincode.hashCode ^
        country.hashCode ^
        state.hashCode ^
        category.hashCode;
  }
}

class Contest {
  final int id;
  final String contest_name;
  Contest({
    required this.id,
    required this.contest_name,
  });

  Contest copyWith({
    int? id,
    String? contest_name,
  }) {
    return Contest(
      id: id ?? this.id,
      contest_name: contest_name ?? this.contest_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contest_name': contest_name,
    };
  }

  factory Contest.fromMap(Map<String, dynamic> map) {
    return Contest(
      id: map['id'] as int,
      contest_name: map['contest_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contest.fromJson(String source) =>
      Contest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Contest(id: $id, contest_name: $contest_name)';

  @override
  bool operator ==(covariant Contest other) {
    if (identical(this, other)) return true;

    return other.id == id && other.contest_name == contest_name;
  }

  @override
  int get hashCode => id.hashCode ^ contest_name.hashCode;
}

class Ticket {
  final int id;
  Ticket({
    required this.id,
  });

  Ticket copyWith({
    int? id,
  }) {
    return Ticket(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) =>
      Ticket.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Ticket(id: $id)';

  @override
  bool operator ==(covariant Ticket other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
