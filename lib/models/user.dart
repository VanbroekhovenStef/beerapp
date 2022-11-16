class User {
  String id;
  String name;
  String dateOfBirth;
  String firstName;

  User({required this.id, required this.name, required this.dateOfBirth, required this.firstName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      firstName: json['firstName']
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'dateOfBirth': dateOfBirth,
        'firstName': firstName
      };
}
