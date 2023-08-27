import 'package:crm_application/Models/LeadsModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/statusModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/stausmodel.dart';
import 'package:intl/intl.dart';

class ColdCalls {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? dob;
  SourceModel? source;
  String? comments;
  Agent? agent;
  String? assignedDate;
  String? coldCallPreority;
  int? isDeleted;
  String? deletedDate;
  int? isExpected;
  String? remindMeAt;
  int? remindMeSent;
  String? status;
  ColdCallStatus? coldcallsStatus;
  String? createdAt;
  String? updatedAt;

  ColdCalls(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.dob,
      this.source,
      this.comments,
      this.agent,
      this.assignedDate,
      this.coldCallPreority,
      this.isDeleted,
      this.deletedDate,
      this.isExpected,
      this.remindMeAt,
      this.remindMeSent,
      this.status,
      this.coldcallsStatus,
      this.createdAt,
      this.updatedAt});

  ColdCalls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'] != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(json['dob']))
        : null;
    source =
        json['source'] != null ? SourceModel.fromJson(json['source']) : null;
    comments = json['comments'];
    agent = json['agent'] != null ? Agent.fromJson(json['agent']) : null;
    assignedDate = json['assigned_date'];
    coldCallPreority = json['cold_call_preority'];
    isDeleted = json['is_deleted'];
    deletedDate = json['deleted_date'];
    isExpected = json['is_expected'];
    remindMeAt = json['remind_me_at'];
    remindMeSent = json['remind_me_sent'];
    status = json['status'];
    coldcallsStatus = json['coldcalls_status'] != null
        ? ColdCallStatus.fromJson(json['coldcalls_status'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['dob'] = dob != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(dob!))
        : null;
    data['source'] = source != null ? source!.toJson() : null;
    data['comments'] = comments;
    data['agent'] = agent != null ? agent!.toJson() : null;
    data['assigned_date'] = assignedDate;
    data['cold_call_preority'] = coldCallPreority;
    data['is_deleted'] = isDeleted;
    data['deleted_date'] = deletedDate;
    data['is_expected'] = isExpected;
    data['remind_me_at'] = remindMeAt;
    data['remind_me_sent'] = remindMeSent;
    data['status'] = status;
    data['coldcalls_status'] =
        coldcallsStatus != null ? coldcallsStatus!.toJson() : null;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ColdCallsByDate {
  ColdCallsByDate({
    required this.date,
    this.coldCalls,
  });

  String date;
  List<ColdCalls>? coldCalls;
}
