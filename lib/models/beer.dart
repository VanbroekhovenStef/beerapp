
class Beer {
  int id;
  String name;
  String picture;
  String description;
  String type;
  double alcoholpercentage;
  // int breweryId;
  String barcode;

  Beer({
    required this.id,
    required this.name,
    required this.picture,
    required this.description,
    required this.type,
    required this.alcoholpercentage,
    // required this.breweryId,
    required this.barcode,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'],
      name: json['name'],
      picture: json['picture'],
      description: json['description'],
      type: json['type'],
      alcoholpercentage: json['alcoholpercentage'],
      // breweryId: json['breweryId'],
      barcode: json['barcode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'picture': picture,
        'description': description,
        'type': type,
        'alcoholpercentage': alcoholpercentage,
        // 'breweryId': breweryId,
        'barcode': barcode,
      };
}
