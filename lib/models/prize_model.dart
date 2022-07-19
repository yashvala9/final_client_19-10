// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'prize_img_model.dart';

class PrizeModel {
  final int id;
  final int contest;
  final String prizeName;
  final List<PrizeImageModel> prizeImg;
  PrizeModel({
    required this.id,
    required this.contest,
    required this.prizeName,
    required this.prizeImg,
  });

  PrizeModel copyWith({
    int? id,
    int? contest,
    String? prizeName,
    List<PrizeImageModel>? prizeImg,
  }) {
    return PrizeModel(
      id: id ?? this.id,
      contest: contest ?? this.contest,
      prizeName: prizeName ?? this.prizeName,
      prizeImg: prizeImg ?? this.prizeImg,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contest': contest,
      'prizeName': prizeName,
      'prizeImg': prizeImg.map((x) => x.toMap()).toList(),
    };
  }

  factory PrizeModel.fromMap(Map<String, dynamic> map) {
    return PrizeModel(
      id: map['id'] as int,
      contest: map['contest'] as int,
      prizeName: map['prizeName'] as String,
      prizeImg: List<PrizeImageModel>.from(
        (map['prizeImg'] as List<int>).map<PrizeImageModel>(
          (x) => PrizeImageModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrizeModel.fromJson(String source) =>
      PrizeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PrizeModel(id: $id, contest: $contest, prizeName: $prizeName, prizeImg: $prizeImg)';
  }

  @override
  bool operator ==(covariant PrizeModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.contest == contest &&
        other.prizeName == prizeName &&
        listEquals(other.prizeImg, prizeImg);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contest.hashCode ^
        prizeName.hashCode ^
        prizeImg.hashCode;
  }
}
