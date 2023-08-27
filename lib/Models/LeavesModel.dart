import 'package:crm_application/Models/LeadsModel.dart';

class LeavesTypeModel {
  final int id;
  final String leavetype;
  final String description;
  final String created_at;
  final String updated_at;
  LeavesTypeModel(
      {required this.id,
      required this.leavetype,
      required this.description,
      required this.created_at,
      required this.updated_at});

  factory LeavesTypeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LeavesTypeModel(
        id: json['id']!,
        leavetype: json['leavetype']!,
        description: json['description']!,
        created_at: json['created_at']!,
        updated_at: json['updated_at']!);
  }
}

class AllLeaves {
  List<Leaves>? leaves;
  List<Leaves>? approvedleaves;
  List<Leaves>? waitingleaves;
  List<Leaves>? notapprovedleaves;

  AllLeaves(
      {this.leaves,
      this.approvedleaves,
      this.waitingleaves,
      this.notapprovedleaves});

  AllLeaves.fromJson(Map<String, dynamic> json) {
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
    if (json['approvedleaves'] != null) {
      approvedleaves = <Leaves>[];
      json['approvedleaves'].forEach((v) {
        approvedleaves!.add(new Leaves.fromJson(v));
      });
    }
    if (json['waitingleaves'] != null) {
      waitingleaves = <Leaves>[];
      json['waitingleaves'].forEach((v) {
        waitingleaves!.add(new Leaves.fromJson(v));
      });
    }
    if (json['notapprovedleaves'] != null) {
      notapprovedleaves = <Leaves>[];
      json['notapprovedleaves'].forEach((v) {
        notapprovedleaves!.add(new Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (leaves != null) {
      data['leaves'] = leaves!.map((v) => v.toJson()).toList();
    }
    if (approvedleaves != null) {
      data['approvedleaves'] = approvedleaves!.map((v) => v.toJson()).toList();
    }
    if (waitingleaves != null) {
      data['waitingleaves'] = waitingleaves!.map((v) => v.toJson()).toList();
    }
    if (notapprovedleaves != null) {
      data['notapprovedleaves'] =
          notapprovedleaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  int? id;
  int? leaveTypeId;
  String? toDate;
  String? fromDate;
  String? description;
  String? postingDate;
  String? adminRemark;
  String? adminRemarkDate;
  int? status;
  int? isHrApprovel;
  int? isReportingPersonApprovel;
  int? isRead;
  int? userId;
  Agent? agent;
  String? createdAt;
  String? updatedAt;

  Leaves(
      {this.id,
      this.leaveTypeId,
      this.toDate,
      this.fromDate,
      this.description,
      this.postingDate,
      this.adminRemark,
      this.adminRemarkDate,
      this.status,
      this.isHrApprovel,
      this.isReportingPersonApprovel,
      this.isRead,
      this.userId,
      this.agent,
      this.createdAt,
      this.updatedAt});

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaveTypeId = json['leave_type_id'];
    toDate = json['to_date'];
    fromDate = json['from_date'];
    description = json['description'];
    postingDate = json['posting_date'];
    adminRemark = json['admin_remark'];
    adminRemarkDate = json['admin_remark_date'];
    status = json['status'];
    isHrApprovel = json['is_hr_approvel'];
    isReportingPersonApprovel = json['is_reporting_person_approvel'];
    isRead = json['is_read'];
    userId = json['user_id'];
    agent = json['agent'] != null ? Agent.fromJson(json['agent']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['leave_type_id'] = leaveTypeId;
    data['to_date'] = toDate;
    data['from_date'] = fromDate;
    data['description'] = description;
    data['posting_date'] = postingDate;
    data['admin_remark'] = adminRemark;
    data['admin_remark_date'] = adminRemarkDate;
    data['status'] = status;
    data['is_hr_approvel'] = isHrApprovel;
    data['is_reporting_person_approvel'] = isReportingPersonApprovel;
    data['is_read'] = isRead;
    data['user_id'] = userId;
    data['agent'] = agent;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
