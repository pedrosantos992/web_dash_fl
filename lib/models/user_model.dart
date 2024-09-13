class UserModel {
  int id;
  String name;
  String username;
  String email;
  String country;
  String shirtSize;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.country,
    required this.shirtSize,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      country: json['country'],
      shirtSize: json['shirt_size'],
    );
  }
}
