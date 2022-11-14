class ARBeerResponse {
  int beerId;
  bool isAdd;

  ARBeerResponse({required this.beerId, required this.isAdd});

  factory ARBeerResponse.fromJson(Map<String, dynamic> json) {
    return ARBeerResponse(
      beerId: json['beerId'],
      isAdd: json['isAdd']
    );
  }
}
