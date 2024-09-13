class Company {
  final String name;
  final String catchPhrase;

  Company({
    required this.name,
    required this.catchPhrase,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
    );
  }
}

class UserModel {
  int id;
  String name;
  String username;
  String email;
  final Company company;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      company: Company.fromJson(json['company']),
    );
  }
}
