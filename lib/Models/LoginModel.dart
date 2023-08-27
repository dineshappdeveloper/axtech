// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.success,
    required this.message,
    required this.results,
  });

  int success;
  String message;
  Results results;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"],
    message: json["message"],
    results: Results.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "results": results.toJson(),
  };
}

class Results {
  Results({
    required this.token,
    required this.tokenType,
    required this.expiresAt,
    required this.role,
    required this.data,
  });

  String token;
  String tokenType;
  DateTime expiresAt;
  String role;
  Data data;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    token: json["token"],
    tokenType: json["token_type"],
    expiresAt: DateTime.parse(json["expires_at"]),
    role: json["role"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "token_type": tokenType,
    "expires_at": expiresAt.toIso8601String(),
    "role": role,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  int phone;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
  };
}
