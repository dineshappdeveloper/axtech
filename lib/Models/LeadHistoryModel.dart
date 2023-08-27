// To parse this JSON data, do
//
//     final leadHistoryModel = leadHistoryModelFromJson(jsonString);

import 'dart:convert';

LeadHistoryModel leadHistoryModelFromJson(String str) => LeadHistoryModel.fromJson(json.decode(str));

String leadHistoryModelToJson(LeadHistoryModel data) => json.encode(data.toJson());

class LeadHistoryModel {
  LeadHistoryModel({
    required this.success,
    required this.data,
    required this.message,
  });

  int success;
  List<LeadHistory> data;
  String message;

  factory LeadHistoryModel.fromJson(Map<String, dynamic> json) => LeadHistoryModel(
    success: json["success"],
    data: List<LeadHistory>.from(json["data"].map((x) => LeadHistory.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class LeadHistory {
  LeadHistory({
    required this.id,
    required this.leadId,
    required this.iHaveDone,
    required this.interestedProjects,
    required this.clientPriority,
    required this.planToDo,
    required this.scheduleTime,
    required this.scheduleDate,
    required this.reminderSent,
    required this.joinWithEmployee,
    required this.agentId,
    required this.comment,
    required this.followupStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  int? leadId;
  String? iHaveDone;
  int? interestedProjects;
  String? clientPriority;
  String? planToDo;
  String? scheduleTime;
  String? scheduleDate;
  int? reminderSent;
  String? joinWithEmployee;
  int? agentId;
  String? comment;
  String? followupStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory LeadHistory.fromJson(Map<String, dynamic> json) => LeadHistory(
    id: json["id"],
    leadId: json["lead_id"],
    iHaveDone: json["i_have_done"],
    interestedProjects: json["interested_projects"],
    clientPriority: json["client_priority"],
    planToDo: json["plan_to_do"],
    scheduleTime: json["schedule_time"],
    scheduleDate: json["schedule_date"],
    reminderSent: json["reminder_sent"],
    joinWithEmployee: json["join_with_employee"],
    agentId: json["agent_id"],
    comment: json["comment"],
    followupStatus: json["followup_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lead_id": leadId,
    "i_have_done": iHaveDone,
    "interested_projects": interestedProjects,
    "client_priority": clientPriority,
    "plan_to_do": planToDo,
    "schedule_time": scheduleTime,
    "schedule_date": scheduleDate,
    "reminder_sent": reminderSent,
    "join_with_employee": joinWithEmployee,
    "agent_id": agentId,
    "comment": comment,
    "followup_status": followupStatus,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
