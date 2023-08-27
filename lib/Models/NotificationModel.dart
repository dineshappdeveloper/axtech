class NotificationModel {
  NotificationModel({
    required this.id,
    required this.agent_id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  int? agent_id;
  String? title;
  String? message;
  DateTime createdAt;
  DateTime? updatedAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        agent_id: json["agent_id"],
        title: json["title"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agent_id": agent_id,
        "title": title,
        "message": message,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
