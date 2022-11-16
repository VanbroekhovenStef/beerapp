import 'beer.dart';

class Consumption {
  String id;
  String beerId;
  String userId;
  int score;
  int count;
  String createdAt;
  String remark;
  Beer? beer;

  Consumption({
    required this.id,
    required this.beerId,
    required this.userId,
    required this.score,
    required this.count,
    required this.createdAt,
    required this.remark,
    this.beer,
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
        'beer': beer
      };
}
