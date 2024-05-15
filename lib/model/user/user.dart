

import '../config/config.dart';
import '../node/node.dart';
import '../role/role.dart';

class User {
  int id;
  String username;
  String password;
  String name;
  String email;
  String phoneNumber;
  DateTime createdAt;
  DateTime updatedAt;
  String error;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.error,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      error: json['error'] ?? '',
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),

    );
  }



}