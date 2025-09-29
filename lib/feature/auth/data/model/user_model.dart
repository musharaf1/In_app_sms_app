import 'package:inapp_sms/core/entities/user.dart';

class UserModel extends User {
  UserModel({required super.email, required super.id, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? "",
    );
  }

  UserModel copyWith({String? id, String? name, String? email}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
