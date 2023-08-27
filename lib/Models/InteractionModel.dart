// To parse this JSON data, do
//
//     final interactionModel = interactionModelFromJson(jsonString);

import 'dart:convert';

InteractionModel interactionModelFromJson(String str) =>
    InteractionModel.fromJson(json.decode(str));

String interactionModelToJson(InteractionModel data) =>
    json.encode(data.toJson());

class InteractionModel {
  InteractionModel({
    required this.success,
    required this.missed,
    required this.today,
    required this.upcoming,
    required this.overll,
    required this.message,
  });

  int? success;
  List<Missed>? missed;
  List<dynamic>? today;
  List<Upcoming>? upcoming;
  List<Missed>? overll;
  String? message;

  factory InteractionModel.fromJson(Map<String, dynamic> json) =>
      InteractionModel(
        success: json["success"],
        missed:
            List<Missed>.from(json["missed"].map((x) => Missed.fromJson(x))),
        today: List<dynamic>.from(json["today"].map((x) => x)),
        upcoming: List<Upcoming>.from(
            json["upcoming"].map((x) => Upcoming.fromJson(x))),
        overll:
            List<Missed>.from(json["overll"].map((x) => Missed.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "missed": List<dynamic>.from(missed!.map((x) => x.toJson())),
        "today": List<dynamic>.from(today!.map((x) => x)),
        "upcoming": List<dynamic>.from(upcoming!.map((x) => x.toJson())),
        "overll": List<dynamic>.from(overll!.map((x) => x.toJson())),
        "message": message,
      };
}

class Missed {
  Missed({
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
    required this.leads,
  });

  int id;
  int leadId;
  String? iHaveDone;
  int? interestedProjects;
  String? clientPriority;
  String? planToDo;
  String? scheduleTime;
  DateTime? scheduleDate;
  int? reminderSent;
  String? joinWithEmployee;
  int? agentId;
  String? comment;
  String? followupStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<MissedLead> leads;

  factory Missed.fromJson(Map<String, dynamic> json) => Missed(
        id: json["id"],
        leadId: json["lead_id"],
        iHaveDone: json["i_have_done"].toString(),
        interestedProjects: json["interested_projects"],
        clientPriority: json["client_priority"],
        planToDo: json["plan_to_do"],
        scheduleTime: json["schedule_time"],
        scheduleDate: DateTime.parse(json["schedule_date"]),
        reminderSent: json["reminder_sent"],
        joinWithEmployee: json["join_with_employee"] ?? ' ',
        agentId: json["agent_id"],
        comment: json["comment"],
        followupStatus: json["followup_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        leads: List<MissedLead>.from(
            json["leads"].map((x) => MissedLead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "i_have_done": iHaveDone,
        "interested_projects": interestedProjects,
        "client_priority": clientPriority,
        "plan_to_do": planToDo,
        "schedule_time": scheduleTime,
        "schedule_date":
            "${scheduleDate!.year.toString().padLeft(4, '0')}-${scheduleDate!.month.toString().padLeft(2, '0')}-${scheduleDate!.day.toString().padLeft(2, '0')}",
        "reminder_sent": reminderSent,
        "join_with_employee":
            joinWithEmployee ?? null,
        "agent_id": agentId,
        "comment": comment,
        "followup_status": followupStatus,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "leads": List<dynamic>.from(leads.map((x) => x.toJson())),
      };
}

class MissedLead {
  MissedLead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.altPhone,
    required this.date,
    required this.dob,
    required this.source,
    required this.priority,
    required this.comment,
    required this.additionalComment,
    required this.customerId,
    required this.developerId,
    required this.propertyId,
    required this.propertyPreference,
    required this.jobProfile,
    required this.avgIncome,
    required this.status,
    required this.attachment,
    required this.type,
    required this.amount,
    //required   this.closedDate,
    required this.closeBy,
    required this.leadId,
    required this.agentId,
    required this.review,
    required this.createdBy,
    required this.assignLeadsCount,
    required this.customer,
    // required  this.developer,
    required this.property,
    required this.agents,
    required this.statuses,
    required this.leadUser,
    required this.sources,
    //required this.notes,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  dynamic altPhone;
  DateTime date;
  String? dob;
  String? source;
  String? priority;
  String? comment;
  dynamic additionalComment;
  dynamic customerId;
  int? developerId;
  int? propertyId;
  String? propertyPreference;
  dynamic jobProfile;
  String? avgIncome;
  int? status;
  dynamic attachment;
  String? type;
  String? amount;
//  DateTime closedDate;
  int? closeBy;
  String? leadId;
  int? agentId;
  dynamic review;
  int createdBy;
  int assignLeadsCount;
  dynamic customer;
  //Developer developer;
  Property? property;
  List<PurpleAgent> agents;
  Statuses statuses;
  LeadUser? leadUser;
  Sources sources;
  //List<dynamic> notes;

  factory MissedLead.fromJson(Map<String, dynamic> json) => MissedLead(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        altPhone: json["alt_phone"],
        date: DateTime.parse(json["date"]),
        dob: json["dob"],
        source: json["source"],
        priority: json["priority"],
        comment: json["comment"],
        additionalComment: json["additional_comment"],
        customerId: json["customer_id"],
        developerId: json["developer_id"],
        propertyId: json["property_id"],
        propertyPreference: json["property_preference"],
        jobProfile: json["job_profile"],
        avgIncome: json["avg_income"],
        status: json["status"],
        attachment: json["attachment"],
        type: json["type"],
        amount: json["amount"],
        //closedDate:  DateTime.parse(json["closed_date"]),
        closeBy: json["close_by"],
        leadId: json["lead_id"],
        agentId: json["agent_id"],
        review: json["review"],
        createdBy: json["created_by"],
        assignLeadsCount: json["assign_leads_count"],
        customer: json["customer"],
        //developer: Developer.fromJson(json["developer"]),
        property: Property.fromJson(json["property"] ?? {}),
        agents: List<PurpleAgent>.from(
            json["agents"].map((x) => PurpleAgent.fromJson(x))),
        statuses: Statuses.fromJson(json["statuses"] ?? {}),
        leadUser: json["lead_user"]!=null?LeadUser.fromJson(json["lead_user"]):null,
        sources: Sources.fromJson(json["sources"]),
        //notes: List<dynamic>.from(json["notes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "alt_phone": altPhone,
        "date": date.toIso8601String(),
        "dob": dob == null ? null : dob,
        "source": source,
        "priority": priority == null ? null : priority,
        "comment": comment == null ? null : comment,
        "additional_comment": additionalComment,
        "customer_id": customerId,
        "developer_id": developerId,
        "property_id": propertyId == null ? null : propertyId,
        "property_preference":
            propertyPreference == null ? null : propertyPreference,
        "job_profile": jobProfile,
        "avg_income": avgIncome == null ? null : avgIncome,
        "status": status,
        "attachment": attachment,
        "type": type,
        "amount": amount,
        //"closed_date": closedDate == null ? null : closedDate.toIso8601String(),
        "close_by": closeBy == null ? null : closeBy,
        "lead_id": leadId,
        "agent_id": agentId == null ? null : agentId,
        "review": review,
        "created_by": createdBy,
        "assign_leads_count": assignLeadsCount,
        "customer": customer,
        //"developer": developer.toJson(),
        "property": property!.toJson(),
        "agents": List<dynamic>.from(agents.map((x) => x.toJson())),
        "statuses": statuses.toJson(),
        "lead_user": leadUser!=null?leadUser!.toJson():null,
        "sources": sources.toJson(),
        //"notes": List<dynamic>.from(notes.map((x) => x)),
      };
}

class PurpleAgent {
  PurpleAgent({
    required this.id,
    required this.designationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
    required this.phone,
    required this.reportingPerson,
    required this.atContact,
    required this.address,
    required this.oldPassword,
    required this.deviceToken,
    required this.userProfile,
    required this.deviceId,
    required this.isExcluded,
    required this.permissionMenu,
    required this.dataOfJoining,
    required this.bloodGroup,
    required this.emergencyContactNumber,
    required this.emergencyContactName,
//  required   this.emergencyContactRelationship,
    required this.addressInUae,
    required this.nationality,
    required this.medicalConditions,
    // required   this.maritalStatus,
    required this.visaType,
//  required   this.educationDetails,
    required this.createdBy,
    required this.createdAt,
    required this.pivot,
//   required  this.metaData,
//   required  this.metas,
  });

  int? id;
  int? designationId;
  String? firstName;
  String? lastName;
  String? email;
  dynamic dob;
  int? phone;
  int? reportingPerson;
  dynamic atContact;
  String? address;
  String? oldPassword;
  String? deviceToken;
  String? userProfile;
  dynamic deviceId;
  int? isExcluded;
  int? permissionMenu;
  dynamic dataOfJoining;
  dynamic bloodGroup;
  dynamic emergencyContactNumber;
  dynamic emergencyContactName;
  // EducationDetails emergencyContactRelationship;
  dynamic addressInUae;
  dynamic nationality;
  dynamic medicalConditions;
  // EducationDetails maritalStatus;
  dynamic visaType;
  // EducationDetails educationDetails;
  dynamic createdBy;
  DateTime? createdAt;
  Pivot? pivot;
//  Map<String, EducationDetails> metaData;
//  List<Meta> metas;

  factory PurpleAgent.fromJson(Map<String, dynamic> json) => PurpleAgent(
        id: json["id"],
        designationId: json["designation_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        dob: json["dob"],
        phone: json["phone"],
        reportingPerson: json["reporting_person"],
        atContact: json["at_contact"],
        address: json["address"],
        oldPassword: json["old_password"],
        deviceToken: json["device_token"],
        userProfile: json["user_profile"],
        deviceId: json["device_id"],
        isExcluded: json["is_excluded"],
        permissionMenu: json["permission_menu"],
        dataOfJoining: json["data_of_joining"],
        bloodGroup: json["blood_group"],
        emergencyContactNumber: json["emergency_contact_number"],
        emergencyContactName: json["emergency_contact_name"],
        //  emergencyContactRelationship: json["emergency_contact_relationship"] == null ? null : educationDetailsValues.map[json["emergency_contact_relationship"]],
        addressInUae: json["address_in_uae"],
        nationality: json["nationality"],
        medicalConditions: json["medical_conditions"],
        //  maritalStatus:  educationDetailsValues.map[json["marital_status"]??{}],
        visaType: json["visa_type"],
        //  educationDetails: json["education_details"] == null ? null : educationDetailsValues.map[json["education_details"]],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
        //  metaData: Map.from(json["meta_data"]).map((k, v) => MapEntry<String, EducationDetails>(k, v == null ? null : educationDetailsValues.map[v])),
        //  metas: json["metas"] == null ? null : List<Meta>.from(json["metas"].map((x) => Meta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "designation_id": designationId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "dob": dob,
        "phone": phone,
        "reporting_person": reportingPerson,
        "at_contact": atContact,
        "address": address == null ? null : address,
        "old_password": oldPassword == null ? null : oldPassword,
        "device_token": deviceToken == null ? null : deviceToken,
        "user_profile": userProfile,
        "device_id": deviceId,
        "is_excluded": isExcluded,
        "permission_menu": permissionMenu,
        "data_of_joining": dataOfJoining,
        "blood_group": bloodGroup,
        "emergency_contact_number": emergencyContactNumber,
        "emergency_contact_name": emergencyContactName,
        //  "emergency_contact_relationship": emergencyContactRelationship == null ? null : educationDetailsValues.reverse[],
        "address_in_uae": addressInUae,
        "nationality": nationality,
        "medical_conditions": medicalConditions,
        //  "marital_status": maritalStatus == null ? null : educationDetailsValues.reverse[maritalStatus],
        "visa_type": visaType,
        //   "education_details": educationDetails == null ? null : educationDetailsValues.reverse[educationDetails],
        "created_by": createdBy,
        "created_at": createdAt!.toIso8601String(),
        "pivot": pivot!.toJson(),
//    "meta_data": Map.from(metaData).map((k, v) => MapEntry<String, dynamic>(k, v == null ? null : educationDetailsValues.reverse[v])),
//    "metas": metas == null ? null : List<dynamic>.from(metas.map((x) => x.toJson())),
      };
}

enum EducationDetails { THE_8081008927, MANOJ_RANGE_AE, BACHELOR, HIGH_SCHOOL }

final educationDetailsValues = EnumValues({
  "bachelor": EducationDetails.BACHELOR,
  "high_school": EducationDetails.HIGH_SCHOOL,
  "manoj@range.ae": EducationDetails.MANOJ_RANGE_AE,
  "8081008927": EducationDetails.THE_8081008927
});

class Meta {
  Meta({
    required this.id,
    required this.userId,
    required this.type,
    required this.key,
    //required  this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  int? userId;
  Type? type;
  String? key;
//  EducationDetails value;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        id: json["id"],
        userId: json["user_id"],
        type: typeValues.map[json["type"]],
        key: json["key"],
        // value: json["value"] == null ? null : educationDetailsValues.map[json["value"]],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": typeValues.reverse[type],
        "key": key,
        //  "value": value == null ? null : educationDetailsValues.reverse[value],
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

enum Type { STRING, NULL }

final typeValues = EnumValues({"NULL": Type.NULL, "string": Type.STRING});

class Pivot {
  Pivot({
    required this.leadId,
    required this.userId,
  });

  int leadId;
  int userId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        leadId: json["lead_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "lead_id": leadId,
        "user_id": userId,
      };
}

class Developer {
  Developer(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address,
      required this.createdAt,
      required this.updatedAt,
      required});

  int id;
  String? name;
  String? phone;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Developer.fromJson(Map<String, dynamic>? json) => Developer(
        id: json!["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "address": address,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class LeadUser {
  LeadUser({
    required this.id,
    required this.leadId,
    required this.userId,
  });

  int id;
  int? leadId;
  int? userId;

  factory LeadUser.fromJson(Map<String, dynamic> json) => LeadUser(
        id: json["id"],
        leadId: json["lead_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "user_id": userId,
      };
}

class Property {
  Property({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.cityId,
    required this.address,
    required this.developerId,
    required this.budget,
    required this.image,
    required this.featuredProperty,
    // required this.createdAt,
//  required this.updatedAt,
    //  required this.ameneties,
  });

  int? id;
  String? name;
  String? slug;
  String? description;
  int? cityId;
  String? address;
  int? developerId;
  String? budget;
  String? image;
  String? featuredProperty;
  // DateTime createdAt;
// DateTime updatedAt;
//  List<dynamic> ameneties;

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"] ?? '',
        cityId: json["city_id"],
        address: json["address"],
        developerId: json["developer_id"],
        budget: json["budget"],
        image: json["image"],
        featuredProperty: json["featured_property"],
        //createdAt: DateTime.parse(json["created_at"]),
        //updatedAt: DateTime.parse(json["updated_at"]),
        // ameneties: List<dynamic>.from(json["ameneties"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "city_id": cityId,
        "address": address,
        "developer_id": developerId,
        "budget": budget,
        "image": image,
        "featured_property": featuredProperty,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        //   "ameneties": List<dynamic>.from(ameneties.map((x) => x)),
      };
}

class Sources {
  Sources({
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

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
        id: json["id"],
        name: json["name"],
        status: json["status"].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status == null ? null : status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Statuses {
  Statuses({
    required this.id,
    required this.name,
    required this.statusorder,
    required this.color,
    required this.isdefault,
    //required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? name;
  int? statusorder;
  String? color;
  int? isdefault;
  //DateTime createdAt;
  dynamic updatedAt;

  factory Statuses.fromJson(Map<String, dynamic> json) => Statuses(
        id: json["id"],
        name: json["name"],
        statusorder: json["statusorder"],
        color: json["color"],
        isdefault: json["isdefault"],
        //createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "statusorder": statusorder,
        "color": color,
        "isdefault": isdefault,
        //"created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}

class Upcoming {
  Upcoming({
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
    required this.leads,
  });

  int? id;
  int? leadId;
  String? iHaveDone;
  int? interestedProjects;
  String? clientPriority;
  String? planToDo;
  String? scheduleTime;
  DateTime scheduleDate;
  int? reminderSent;
  dynamic joinWithEmployee;
  int? agentId;
  String? comment;
  String? followupStatus;
  DateTime createdAt;
  DateTime updatedAt;
  List<UpcomingLead> leads;

  factory Upcoming.fromJson(Map<String, dynamic> json) => Upcoming(
        id: json["id"],
        leadId: json["lead_id"],
        iHaveDone: json["i_have_done"],
        interestedProjects: json["interested_projects"],
        clientPriority: json["client_priority"],
        planToDo: json["plan_to_do"],
        scheduleTime: json["schedule_time"],
        scheduleDate: DateTime.parse(json["schedule_date"]),
        reminderSent: json["reminder_sent"],
        joinWithEmployee: json["join_with_employee"],
        agentId: json["agent_id"],
        comment: json["comment"],
        followupStatus: json["followup_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        leads: List<UpcomingLead>.from(
            json["leads"].map((x) => UpcomingLead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "i_have_done": iHaveDone,
        "interested_projects": interestedProjects,
        "client_priority": clientPriority,
        "plan_to_do": planToDo,
        "schedule_time": scheduleTime,
        "schedule_date":
            "${scheduleDate.year.toString().padLeft(4, '0')}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}",
        "reminder_sent": reminderSent,
        "join_with_employee": joinWithEmployee,
        "agent_id": agentId,
        "comment": comment,
        "followup_status": followupStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "leads": List<dynamic>.from(leads.map((x) => x.toJson())),
      };
}

class UpcomingLead {
  UpcomingLead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.altPhone,
    required this.date,
    required this.dob,
    required this.source,
    required this.priority,
    required this.comment,
    required this.additionalComment,
    required this.customerId,
    required this.developerId,
    required this.propertyId,
    required this.propertyPreference,
    required this.jobProfile,
    required this.avgIncome,
    required this.status,
    required this.attachment,
    required this.type,
    required this.amount,
    required this.closedDate,
    required this.closeBy,
    required this.leadId,
    required this.agentId,
    required this.review,
    required this.createdBy,
    required this.assignLeadsCount,
    required this.customer,
    // required this.developer,
    required this.property,
    required this.agents,
    required this.statuses,
    required this.leadUser,
    required this.sources,
    // required this.notes,
  });

  int id;
  String? name;
  String? email;
  String? phone;
  dynamic altPhone;
  DateTime date;
  String? dob;
  String? source;
  String? priority;
  String? comment;
  dynamic additionalComment;
  dynamic customerId;
  int developerId;
  dynamic propertyId;
  dynamic propertyPreference;
  dynamic jobProfile;
  String? avgIncome;
  int? status;
  dynamic attachment;
  String? type;
  String ? amount;
  DateTime? closedDate;
  int? closeBy;
  String? leadId;
  int? agentId;
  dynamic review;
  int? createdBy;
  int? assignLeadsCount;
  dynamic customer;
  // Developer? developer;
  dynamic property;
  List<FluffyAgent>? agents;
  Statuses? statuses;
  LeadUser? leadUser;
  Sources? sources;
  // List<dynamic>? notes;

  factory UpcomingLead.fromJson(Map<String, dynamic> json) => UpcomingLead(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        altPhone: json["alt_phone"],
        date: DateTime.parse(json["date"]),
        dob: json["dob"],
        source: json["source"],
        priority: json["priority"],
        comment: json["comment"],
        additionalComment: json["additional_comment"],
        customerId: json["customer_id"],
        developerId: json["developer_id"],
        propertyId: json["property_id"],
        propertyPreference: json["property_preference"],
        jobProfile: json["job_profile"],
        avgIncome: json["avg_income"],
        status: json["status"],
        attachment: json["attachment"],
        type: json["type"],
        amount: json["amount"],
        closedDate: DateTime.parse(json["closed_date"]),
        closeBy: json["close_by"],
        leadId: json["lead_id"],
        agentId: json["agent_id"],
        review: json["review"],
        createdBy: json["created_by"],
        assignLeadsCount: json["assign_leads_count"],
        customer: json["customer"],
        // developer: Developer.fromJson(json["developer"]),
        property: json["property"],
        agents: List<FluffyAgent>.from(
            json["agents"].map((x) => FluffyAgent.fromJson(x))),
        statuses: Statuses.fromJson(json["statuses"]),
        leadUser: LeadUser.fromJson(json["lead_user"]),
        sources: Sources.fromJson(json["sources"]),
        // notes: List<dynamic>.from(json["notes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "alt_phone": altPhone,
        "date": date.toIso8601String(),
        "dob": dob,
        "source": source,
        "priority": priority,
        "comment": comment,
        "additional_comment": additionalComment,
        "customer_id": customerId,
        "developer_id": developerId,
        "property_id": propertyId,
        "property_preference": propertyPreference,
        "job_profile": jobProfile,
        "avg_income": avgIncome,
        "status": status,
        "attachment": attachment,
        "type": type,
        "amount": amount,
        "closed_date": closedDate!.toIso8601String(),
        "close_by": closeBy,
        "lead_id": leadId,
        "agent_id": agentId,
        "review": review,
        "created_by": createdBy,
        "assign_leads_count": assignLeadsCount,
        "customer": customer,
        // "developer": developer!.toJson(),
        "property": property,
        "agents": List<dynamic>.from(agents!.map((x) => x.toJson())),
        "statuses": statuses!.toJson(),
        "lead_user": leadUser!.toJson(),
        "sources": sources!.toJson(),
        // "notes": List<dynamic>.from(notes! .map((x) => x)),
      };
}

class FluffyAgent {
  FluffyAgent({
    required this.id,
    required this.designationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
    required this.phone,
    required this.reportingPerson,
    required this.atContact,
    required this.address,
    required this.oldPassword,
    required this.deviceToken,
    required this.userProfile,
    required this.deviceId,
    required this.isExcluded,
    required this.permissionMenu,
    required this.dataOfJoining,
    required this.bloodGroup,
    required this.emergencyContactNumber,
    required this.emergencyContactName,
    //  required this.emergencyContactRelationship,
    required this.addressInUae,
    required this.nationality,
    required this.medicalConditions,
//   required this.maritalStatus,
    required this.visaType,
//   required this.educationDetails,
    required this.createdBy,
    required this.createdAt,
    required this.pivot,
//   required this.metaData,
  });

  int? id;
  int? designationId;
  String? firstName;
  String? lastName;
  String? email;
  dynamic dob;
  int? phone;
  int? reportingPerson;
  dynamic atContact;
  String? address;
  String? oldPassword;
  String? deviceToken;
  String? userProfile;
  dynamic deviceId;
  int? isExcluded;
  int? permissionMenu;
  dynamic dataOfJoining;
  dynamic bloodGroup;
  dynamic emergencyContactNumber;
  dynamic emergencyContactName;
//  EducationDetails emergencyContactRelationship;
  dynamic addressInUae;
  dynamic nationality;
  dynamic medicalConditions;
  // EducationDetails maritalStatus;
  dynamic visaType;
//  EducationDetails educationDetails;
  dynamic createdBy;
  DateTime? createdAt;
  Pivot? pivot;
//  Map<String, EducationDetails> metaData;

  factory FluffyAgent.fromJson(Map<String, dynamic> json) => FluffyAgent(
        id: json["id"],
        designationId: json["designation_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        dob: json["dob"],
        phone: json["phone"],
        reportingPerson: json["reporting_person"],
        atContact: json["at_contact"],
        address: json["address"],
        oldPassword: json["old_password"],
        deviceToken: json["device_token"],
        userProfile: json["user_profile"],
        deviceId: json["device_id"],
        isExcluded: json["is_excluded"],
        permissionMenu: json["permission_menu"],
        dataOfJoining: json["data_of_joining"],
        bloodGroup: json["blood_group"],
        emergencyContactNumber: json["emergency_contact_number"],
        emergencyContactName: json["emergency_contact_name"],
//    emergencyContactRelationship: educationDetailsValues.map[json["emergency_contact_relationship"]],
        addressInUae: json["address_in_uae"],
        nationality: json["nationality"],
        medicalConditions: json["medical_conditions"],
        //   maritalStatus: educationDetailsValues.map[json["marital_status"]],
        visaType: json["visa_type"],
//    educationDetails: educationDetailsValues.map[json["education_details"]],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
        //   metaData: Map.from(json["meta_data"]).map((k, v) => MapEntry<String, EducationDetails>(k, v == null ? null : educationDetailsValues.map[v])),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "designation_id": designationId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "dob": dob,
        "phone": phone,
        "reporting_person": reportingPerson,
        "at_contact": atContact,
        "address": address,
        "old_password": oldPassword,
        "device_token": deviceToken,
        "user_profile": userProfile,
        "device_id": deviceId,
        "is_excluded": isExcluded,
        "permission_menu": permissionMenu,
        "data_of_joining": dataOfJoining,
        "blood_group": bloodGroup,
        "emergency_contact_number": emergencyContactNumber,
        "emergency_contact_name": emergencyContactName,
        //  "emergency_contact_relationship": educationDetailsValues.reverse[emergencyContactRelationship],
        "address_in_uae": addressInUae,
        "nationality": nationality,
        "medical_conditions": medicalConditions,
        //   "marital_status": educationDetailsValues.reverse[maritalStatus],
        "visa_type": visaType,
        //  "education_details": educationDetailsValues.reverse[educationDetails],
        "created_by": createdBy,
        "created_at": createdAt!.toIso8601String(),
        "pivot": pivot!.toJson(),
        //   "meta_data": Map.from(metaData).map((k, v) => MapEntry<String, dynamic>(k, v == null ? null : educationDetailsValues.reverse[v])),
      };
}

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
