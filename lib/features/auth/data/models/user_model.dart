import 'package:caco_flutter_blog/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id, 
    required super.email, 
    required super.username
    });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
    );
  }
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }
}