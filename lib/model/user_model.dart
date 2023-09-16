import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String fullname;
  final String username;
  final String email;

  User({
    required this.fullname,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "username": username,
        "email": email,
      };
}
