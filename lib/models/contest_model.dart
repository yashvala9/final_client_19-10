// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'contest_model.dart';

class ContestModel {
  final ContestData Contest;
  final WinnerData? Winner;
  final Winner_userprofile? winner_userprofile;
  final List<Prize> prizes;
  ContestModel({
    required this.Contest,
    required this.Winner,
    required this.winner_userprofile,
    required this.prizes,
  });

  ContestModel copyWith({
    ContestData? Contest,
    WinnerData? Winner,
    Winner_userprofile? winner_userprofile,
    List<Prize>? prizes,
  }) {
    return ContestModel(
      Contest: Contest ?? this.Contest,
      Winner: Winner ?? this.Winner,
      winner_userprofile: winner_userprofile ?? this.winner_userprofile,
      prizes: prizes ?? this.prizes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Contest': Contest.toMap(),
      'Winner': Winner?.toMap(),
      'winner_userprofile': winner_userprofile?.toMap(),
      'prizes': prizes.map((x) => x.toMap()).toList(),
    };
  }

  factory ContestModel.fromMap(Map<String, dynamic> map) {
    return ContestModel(
      Contest: ContestData.fromMap(map['Contest'] as Map<String, dynamic>),
      Winner: map['Winner'] != null
          ? WinnerData.fromMap(map['Winner'] as Map<String, dynamic>)
          : null,
      winner_userprofile: map['winner_userprofile'] != null
          ? Winner_userprofile.fromMap(
              map['winner_userprofile'] as Map<String, dynamic>)
          : null,
      prizes: List<Prize>.from(
        (map['prizes']).map<Prize>(
          (x) => Prize.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContestModel.fromJson(String source) =>
      ContestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContestModel(Contest: $Contest, Winner: $Winner, winner_userprofile: $winner_userprofile, prizes: $prizes)';
  }

  @override
  bool operator ==(covariant ContestModel other) {
    if (identical(this, other)) return true;

    return other.Contest == Contest &&
        other.Winner == Winner &&
        other.winner_userprofile == winner_userprofile &&
        listEquals(other.prizes, prizes);
  }

  @override
  int get hashCode {
    return Contest.hashCode ^
        Winner.hashCode ^
        winner_userprofile.hashCode ^
        prizes.hashCode;
  }
}

class ContestData {
  final String created_at;
  final int id;
  final int creator_id;
  final String start_date;
  final String rules;
  final int prize_count;
  final String status;
  final String updated_at;
  final String contest_name;
  final String creator_type;
  final String end_date;
  final bool is_deleted;
  ContestData({
    required this.created_at,
    required this.id,
    required this.creator_id,
    required this.start_date,
    required this.rules,
    required this.prize_count,
    required this.status,
    required this.updated_at,
    required this.contest_name,
    required this.creator_type,
    required this.end_date,
    required this.is_deleted,
  });

  ContestData copyWith({
    String? created_at,
    int? id,
    int? creator_id,
    String? start_date,
    String? rules,
    int? prize_count,
    String? status,
    String? updated_at,
    String? contest_name,
    String? creator_type,
    String? end_date,
    bool? is_deleted,
  }) {
    return ContestData(
      created_at: created_at ?? this.created_at,
      id: id ?? this.id,
      creator_id: creator_id ?? this.creator_id,
      start_date: start_date ?? this.start_date,
      rules: rules ?? this.rules,
      prize_count: prize_count ?? this.prize_count,
      status: status ?? this.status,
      updated_at: updated_at ?? this.updated_at,
      contest_name: contest_name ?? this.contest_name,
      creator_type: creator_type ?? this.creator_type,
      end_date: end_date ?? this.end_date,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'created_at': created_at,
      'id': id,
      'creator_id': creator_id,
      'start_date': start_date,
      'rules': rules,
      'prize_count': prize_count,
      'status': status,
      'updated_at': updated_at,
      'contest_name': contest_name,
      'creator_type': creator_type,
      'end_date': end_date,
      'is_deleted': is_deleted,
    };
  }

  factory ContestData.fromMap(Map<String, dynamic> map) {
    return ContestData(
      created_at: map['created_at'] as String,
      id: map['id'] as int,
      creator_id: map['creator_id'] as int,
      start_date: map['start_date'] as String,
      rules: map['rules'] as String,
      prize_count: map['prize_count'] as int,
      status: map['status'] as String,
      updated_at: map['updated_at'] as String,
      contest_name: map['contest_name'] as String,
      creator_type: map['creator_type'] as String,
      end_date: map['end_date'] as String,
      is_deleted: map['is_deleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContestData.fromJson(String source) =>
      ContestData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContestData(created_at: $created_at, id: $id, creator_id: $creator_id, start_date: $start_date, rules: $rules, prize_count: $prize_count, status: $status, updated_at: $updated_at, contest_name: $contest_name, creator_type: $creator_type, end_date: $end_date, is_deleted: $is_deleted)';
  }

  @override
  bool operator ==(covariant ContestData other) {
    if (identical(this, other)) return true;

    return other.created_at == created_at &&
        other.id == id &&
        other.creator_id == creator_id &&
        other.start_date == start_date &&
        other.rules == rules &&
        other.prize_count == prize_count &&
        other.status == status &&
        other.updated_at == updated_at &&
        other.contest_name == contest_name &&
        other.creator_type == creator_type &&
        other.end_date == end_date &&
        other.is_deleted == is_deleted;
  }

  @override
  int get hashCode {
    return created_at.hashCode ^
        id.hashCode ^
        creator_id.hashCode ^
        start_date.hashCode ^
        rules.hashCode ^
        prize_count.hashCode ^
        status.hashCode ^
        updated_at.hashCode ^
        contest_name.hashCode ^
        creator_type.hashCode ^
        end_date.hashCode ^
        is_deleted.hashCode;
  }
}

class WinnerData {
  final String updated_at;
  final int user_id;
  final int contest_id;
  final bool is_deleted;
  final String status;
  final String created_at;
  final int id;
  final int ticket_id;
  WinnerData({
    required this.updated_at,
    required this.user_id,
    required this.contest_id,
    required this.is_deleted,
    required this.status,
    required this.created_at,
    required this.id,
    required this.ticket_id,
  });

  WinnerData copyWith({
    String? updated_at,
    int? user_id,
    int? contest_id,
    bool? is_deleted,
    String? status,
    String? created_at,
    int? id,
    int? ticket_id,
  }) {
    return WinnerData(
      updated_at: updated_at ?? this.updated_at,
      user_id: user_id ?? this.user_id,
      contest_id: contest_id ?? this.contest_id,
      is_deleted: is_deleted ?? this.is_deleted,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      id: id ?? this.id,
      ticket_id: ticket_id ?? this.ticket_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'updated_at': updated_at,
      'user_id': user_id,
      'contest_id': contest_id,
      'is_deleted': is_deleted,
      'status': status,
      'created_at': created_at,
      'id': id,
      'ticket_id': ticket_id,
    };
  }

  factory WinnerData.fromMap(Map<String, dynamic> map) {
    return WinnerData(
      updated_at: map['updated_at'] as String,
      user_id: map['user_id'] as int,
      contest_id: map['contest_id'] as int,
      is_deleted: map['is_deleted'] as bool,
      status: map['status'] as String,
      created_at: map['created_at'] as String,
      id: map['id'] as int,
      ticket_id: map['ticket_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WinnerData.fromJson(String source) =>
      WinnerData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WinnerData(updated_at: $updated_at, user_id: $user_id, contest_id: $contest_id, is_deleted: $is_deleted, status: $status, created_at: $created_at, id: $id, ticket_id: $ticket_id)';
  }

  @override
  bool operator ==(covariant WinnerData other) {
    if (identical(this, other)) return true;

    return other.updated_at == updated_at &&
        other.user_id == user_id &&
        other.contest_id == contest_id &&
        other.is_deleted == is_deleted &&
        other.status == status &&
        other.created_at == created_at &&
        other.id == id &&
        other.ticket_id == ticket_id;
  }

  @override
  int get hashCode {
    return updated_at.hashCode ^
        user_id.hashCode ^
        contest_id.hashCode ^
        is_deleted.hashCode ^
        status.hashCode ^
        created_at.hashCode ^
        id.hashCode ^
        ticket_id.hashCode;
  }
}

class Winner_userprofile {
  final String created_at;
  final String updated_at;
  final String gender;
  final String bio;
  final String phone_pin;
  final String current_language;
  final String country;
  final int user_id;
  final String fullname;
  final String profile_img;
  final String phone_number;
  final String state;
  Winner_userprofile({
    required this.created_at,
    required this.updated_at,
    required this.gender,
    required this.bio,
    required this.phone_pin,
    required this.current_language,
    required this.country,
    required this.user_id,
    required this.fullname,
    required this.profile_img,
    required this.phone_number,
    required this.state,
  });

  Winner_userprofile copyWith({
    String? created_at,
    String? updated_at,
    String? gender,
    String? bio,
    String? phone_pin,
    String? current_language,
    String? country,
    int? user_id,
    String? fullname,
    String? profile_img,
    String? phone_number,
    String? state,
  }) {
    return Winner_userprofile(
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      phone_pin: phone_pin ?? this.phone_pin,
      current_language: current_language ?? this.current_language,
      country: country ?? this.country,
      user_id: user_id ?? this.user_id,
      fullname: fullname ?? this.fullname,
      profile_img: profile_img ?? this.profile_img,
      phone_number: phone_number ?? this.phone_number,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'created_at': created_at,
      'updated_at': updated_at,
      'gender': gender,
      'bio': bio,
      'phone_pin': phone_pin,
      'current_language': current_language,
      'country': country,
      'user_id': user_id,
      'fullname': fullname,
      'profile_img': profile_img,
      'phone_number': phone_number,
      'state': state,
    };
  }

  factory Winner_userprofile.fromMap(Map<String, dynamic> map) {
    return Winner_userprofile(
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      gender: map['gender'] as String,
      bio: map['bio'] as String,
      phone_pin: map['phone_pin'] as String,
      current_language: map['current_language'] as String,
      country: map['country'] as String,
      user_id: map['user_id'] as int,
      fullname: map['fullname'] as String,
      profile_img: map['profile_img'] as String,
      phone_number: map['phone_number'] as String,
      state: map['state'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Winner_userprofile.fromJson(String source) =>
      Winner_userprofile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Winner_userprofile(created_at: $created_at, updated_at: $updated_at, gender: $gender, bio: $bio, phone_pin: $phone_pin, current_language: $current_language, country: $country, user_id: $user_id, fullname: $fullname, profile_img: $profile_img, phone_number: $phone_number, state: $state)';
  }

  @override
  bool operator ==(covariant Winner_userprofile other) {
    if (identical(this, other)) return true;

    return other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.gender == gender &&
        other.bio == bio &&
        other.phone_pin == phone_pin &&
        other.current_language == current_language &&
        other.country == country &&
        other.user_id == user_id &&
        other.fullname == fullname &&
        other.profile_img == profile_img &&
        other.phone_number == phone_number &&
        other.state == state;
  }

  @override
  int get hashCode {
    return created_at.hashCode ^
        updated_at.hashCode ^
        gender.hashCode ^
        bio.hashCode ^
        phone_pin.hashCode ^
        current_language.hashCode ^
        country.hashCode ^
        user_id.hashCode ^
        fullname.hashCode ^
        profile_img.hashCode ^
        phone_number.hashCode ^
        state.hashCode;
  }
}

class Prize {
  final int contest_id;
  final String updated_at;
  final String prize_image;
  final bool is_deleted;
  final String prize_name;
  final String created_at;
  final int id;
  final String prize_description;
  Prize({
    required this.contest_id,
    required this.updated_at,
    required this.prize_image,
    required this.is_deleted,
    required this.prize_name,
    required this.created_at,
    required this.id,
    required this.prize_description,
  });

  Prize copyWith({
    int? contest_id,
    String? updated_at,
    String? prize_image,
    bool? is_deleted,
    String? prize_name,
    String? created_at,
    int? id,
    String? prize_description,
  }) {
    return Prize(
      contest_id: contest_id ?? this.contest_id,
      updated_at: updated_at ?? this.updated_at,
      prize_image: prize_image ?? this.prize_image,
      is_deleted: is_deleted ?? this.is_deleted,
      prize_name: prize_name ?? this.prize_name,
      created_at: created_at ?? this.created_at,
      id: id ?? this.id,
      prize_description: prize_description ?? this.prize_description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contest_id': contest_id,
      'updated_at': updated_at,
      'prize_image': prize_image,
      'is_deleted': is_deleted,
      'prize_name': prize_name,
      'created_at': created_at,
      'id': id,
      'prize_description': prize_description,
    };
  }

  factory Prize.fromMap(Map<String, dynamic> map) {
    return Prize(
      contest_id: map['contest_id'] as int,
      updated_at: map['updated_at'] as String,
      prize_image: map['prize_image'] as String,
      is_deleted: map['is_deleted'] as bool,
      prize_name: map['prize_name'] as String,
      created_at: map['created_at'] as String,
      id: map['id'] as int,
      prize_description: map['prize_description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Prize.fromJson(String source) =>
      Prize.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Prize(contest_id: $contest_id, updated_at: $updated_at, prize_image: $prize_image, is_deleted: $is_deleted, prize_name: $prize_name, created_at: $created_at, id: $id, prize_description: $prize_description)';
  }

  @override
  bool operator ==(covariant Prize other) {
    if (identical(this, other)) return true;

    return other.contest_id == contest_id &&
        other.updated_at == updated_at &&
        other.prize_image == prize_image &&
        other.is_deleted == is_deleted &&
        other.prize_name == prize_name &&
        other.created_at == created_at &&
        other.id == id &&
        other.prize_description == prize_description;
  }

  @override
  int get hashCode {
    return contest_id.hashCode ^
        updated_at.hashCode ^
        prize_image.hashCode ^
        is_deleted.hashCode ^
        prize_name.hashCode ^
        created_at.hashCode ^
        id.hashCode ^
        prize_description.hashCode;
  }
}
