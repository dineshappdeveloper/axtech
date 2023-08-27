// To parse this JSON data, do
//
//     final statusListModel = statusListModelFromJson(jsonString);

import 'dart:convert';

StatusListModel statusListModelFromJson(String str) => StatusListModel.fromJson(json.decode(str));

String statusListModelToJson(StatusListModel data) => json.encode(data.toJson());

class StatusListModel {
  StatusListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  int success;
  List<ReasonStatus> data;
  String message;

  factory StatusListModel.fromJson(Map<String, dynamic> json) => StatusListModel(
    success: json["success"],
    data: List<ReasonStatus>.from(json["data"].map((x) => ReasonStatus.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class ReasonStatus {
  ReasonStatus({
    required this.id,
    required this.name,
    required this.statusorder,
    required this.color,
    required this.isdefault,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? name;
  int? statusorder;
  String? color;
  int? isdefault;
  DateTime createdAt;
  DateTime? updatedAt;

  factory ReasonStatus.fromJson(Map<String, dynamic> json) => ReasonStatus(
    id: json["id"],
    name: json["name"],
    statusorder: json["statusorder"],
    color: json["color"],
    isdefault: json["isdefault"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "statusorder": statusorder,
    "color": color,
    "isdefault": isdefault,
    "created_at": createdAt.toIso8601String(),
   "updated_at":updatedAt!.toIso8601String(),
  };
}
