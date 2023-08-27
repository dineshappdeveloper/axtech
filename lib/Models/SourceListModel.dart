// To parse this JSON data, do
//
//     final sourceListModel = sourceListModelFromJson(jsonString);

import 'dart:convert';

SourceListModel sourceListModelFromJson(String str) => SourceListModel.fromJson(json.decode(str));

String sourceListModelToJson(SourceListModel data) => json.encode(data.toJson());

class SourceListModel {
  SourceListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  int success;
  List<SourceList> data;
  String message;

  factory SourceListModel.fromJson(Map<String, dynamic> json) => SourceListModel(
    success: json["success"],
    data: List<SourceList>.from(json["data"].map((x) => SourceList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class SourceList {
  SourceList({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? name;
  String? status;
  DateTime createdAt;
  DateTime updatedAt;

  factory SourceList.fromJson(Map<String, dynamic> json) => SourceList(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
