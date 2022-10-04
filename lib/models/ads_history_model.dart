// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:reel_ro/models/reel_model.dart';

class AdsHistoryModel {
  final int id;
  final int userid;
  final int adsid;
  final int time_duration;
  final ReelModel ads;
  AdsHistoryModel({
    this.id = 0,
    this.userid = 0,
    this.adsid = 0,
    this.time_duration = 0,
    required this.ads,
  });

  AdsHistoryModel copyWith({
    int? id,
    int? userid,
    int? adsid,
    int? time_duration,
    ReelModel? ads,
  }) {
    return AdsHistoryModel(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      adsid: adsid ?? this.adsid,
      time_duration: time_duration ?? this.time_duration,
      ads: ads ?? this.ads,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userid': userid,
      'adsid': adsid,
      'time_duration': time_duration,
      'ads': ads.toMap(),
    };
  }

  factory AdsHistoryModel.fromMap(Map<String, dynamic> map) {
    return AdsHistoryModel(
      id: map['id'] as int,
      userid: map['userid'] as int,
      adsid: map['adsid'] as int,
      time_duration: map['time_duration'] as int,
      ads: ReelModel.fromMap(map['ads'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdsHistoryModel.fromJson(String source) =>
      AdsHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Adshistorymodel(id: $id, userid: $userid, adsid: $adsid, time_duration: $time_duration, ads: $ads)';
  }

  @override
  bool operator ==(covariant AdsHistoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userid == userid &&
        other.adsid == adsid &&
        other.time_duration == time_duration &&
        other.ads == ads;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userid.hashCode ^
        adsid.hashCode ^
        time_duration.hashCode ^
        ads.hashCode;
  }
}
