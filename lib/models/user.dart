class User {
  int id;
  String name;
  String dateOfBirth;

  User(
      {required this.id,
      required this.name,
      required this.dateOfBirth});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'dateOfBirth': dateOfBirth,
      };
}
