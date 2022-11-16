class DataPoint {
  int x;
  double y;

  DataPoint({required this.x, required this.y});

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      x: json['x'],
      y: json['y']
    );
  }
}