class ARBeerResponse {
  String beerName;
  bool isAdd;

  ARBeerResponse({required this.beerName, required this.isAdd});

  factory ARBeerResponse.fromJson(Map<String, dynamic> json) {
    return ARBeerResponse(
      beerName: json['beerName'],
      isAdd: json['isAdd']
    );
  }
}
