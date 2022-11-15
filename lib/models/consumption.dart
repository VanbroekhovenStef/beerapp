import 'package:beerapp/models/datapoint.dart';

import 'beer.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Consumption {
  int id;
  int beerId;
  int userId;
  int score;
  int count;
  String createdAt;
  String remark;
  Beer beer;

  Consumption({
    required this.id,
    required this.beerId,
    required this.userId,
    required this.score,
    required this.count,
    required this.createdAt,
    required this.remark,
    required this.beer,
  });

  factory Consumption.fromJson(Map<String, dynamic> json) {
    return Consumption(
        id: json['id'],
        beerId: json['beerId'],
        userId: json['userId'],
        score: json['score'],
        count: json['count'],
        createdAt: json['createdAt'],
        remark: json['remark'],
        beer: Beer.fromJson(json['beer']));
  }

  Map<String, dynamic> toJson() => {
        'beerId': beerId,
        'userId': userId,
        'score': score,
        'count': count,
        'createdAt': createdAt,
        'remark': remark,
        'beer': beer,
      };
}
