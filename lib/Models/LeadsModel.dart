/*
// To parse this JSON data, do
//
//     final leadsModel = leadsModelFromJson(jsonString);

import 'dart:convert';

LeadsModel leadsModelFromJson(String str) =>
    LeadsModel.fromJson(json.decode(str));

String leadsModelToJson(LeadsModel data) => json.encode(data.toJson());

class LeadsModel {
  LeadsModel({
    required this.success,
    required this.count,
    required this.data,
    required this.message,
  });

  int success;
  int count;
  List<Datum> data;
  String message;

  factory LeadsModel.fromJson(Map<String, dynamic> json) => LeadsModel(
        success: json["success"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Lead {
  Lead({
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
    //required this.additionalComment,
    //required this.customerId,
    //    required this.developerId,
    //    required this.propertyId,
    //    required this.propertyPreference,
    //    required this.jobProfile,
    required this.avgIncome,
    //    required this.status,
    //    required this.attachment,
    //    required this.type,
    required this.amount,
    //    required this.closedDate,
    //    required this.closeBy,
    //    required this.leadId,
    //   required  this.agentId,
    //    required this.review,
    //    required this.createdBy,
    //    required this.assignLeadsCount,
    //    required this.customer,
    //    //required this.developer,
    // //   required this.property,
        required this.agents,
        //required this.statuses,
    //    required this.leadUser,
    required this.sources,
    //required this.notes,
    required this.newComments,
  });

  int id;
  String name;
  String? email;
  String phone;
  String? altPhone;
  DateTime date;
  String? dob;

  String? source;
  String? priority;
  String? comment;

//   dynamic additionalComment;
//   dynamic customerId;
//   int? developerId;
//   int? propertyId;
//   dynamic propertyPreference;
//   dynamic jobProfile;
  String? avgIncome;

//   int? status;
//   dynamic attachment;
//   String? type;
  String? amount;

//   DateTime closedDate;
//   int? closeBy;
//   String? leadId;
//   int? agentId;
//   dynamic review;
//   int? createdBy;
//   int? assignLeadsCount;
//   dynamic customer;
//   //Developer? developer;
// //  Property property;
  List<Agent> agents;
   //Statuses statuses;
//   Datum leadUser;
  Sources sources;

  //List<Note> notes;
  List<NewComment> newComments;

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        altPhone: json["alt_phone"] ?? 'No Alternate Number',
        date: DateTime.parse(json["date"]),
        dob: json["dob"],
        source: json["source"],
        priority: json["priority"],
        comment: json["comment"],
//    additionalComment: json["additional_comment"],
//     customerId: json["customer_id"],
//     developerId:  json["developer_id"],
//     propertyId:  json["property_id"],
//     propertyPreference: json["property_preference"],
//     jobProfile: json["job_profile"],
        avgIncome: json["avg_income"]??'No Data Available',
//     status: json["status"],
//     attachment: json["attachment"],
//     type: json["type"],
        amount: json["amount"],
//     closedDate: DateTime.parse(json["closed_date"]),
//     closeBy: json["close_by"],
//     leadId: json["lead_id"],
//     agentId:  json["agent_id"],
//     review: json["review"],
//     createdBy: json["created_by"],
//     assignLeadsCount: json["assign_leads_count"],
//     customer: json["customer"],
//     //developer:  Developer.fromJson(json["developer"]),
//    // property:  Property.fromJson(json["property"]),
     agents: List<Agent>.from(json["agents"].map((x) => Agent.fromJson(x))),
     //statuses: Statuses.fromJson(json["statuses"]),
//     leadUser: Datum.fromJson(json["lead_user"]),
        sources: Sources.fromJson(json["sources"]??{}),
        //notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
        newComments: List<NewComment>.from(
            json["new_comments"].map((x) => NewComment.fromJson(x))),
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
//     "additional_comment": additionalComment,
//     "customer_id": customerId,
//     "developer_id":  developerId,
//     "property_id":  propertyId,
//     "property_preference": propertyPreference,
//     "job_profile": jobProfile,
        "avg_income": avgIncome,
//     "status": status,
//     "attachment": attachment,
//     "type": type,
//     "amount": amount,
//     "closed_date": closedDate.toIso8601String(),
//     "close_by": closeBy,
//     "lead_id": leadId,
//     "agent_id":  agentId,
//     "review": review,
//     "created_by": createdBy,
//     "assign_leads_count": assignLeadsCount,
//     "customer": customer,
//  //   "developer": developer?.toJson(),
// //    "property": property.toJson(),
    "agents": List<dynamic>.from(agents.map((x) => x.toJson())),
     //"statuses": statuses.toJson(),
//     "lead_user": leadUser.toJson(),
        "sources": sources.toJson(),
       // "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
        "new_comments": List<dynamic>.from(newComments.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.leadId,
    required this.userId,
    required this.lead,
  });

  int id;
  int leadId;
  int userId;
  Lead? lead;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        leadId: json["lead_id"],
        userId: json["user_id"],
        lead: Lead.fromJson(json["lead"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "user_id": userId,
        "lead": lead?.toJson(),
      };
}

class Agent {
  Agent({
    required this.id,
    required this.designationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    */
/*required this.dob,
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
    required this.emergencyContactRelationship,
    required this.addressInUae,
    required this.nationality,
    required this.medicalConditions,
    required this.maritalStatus,
    required this.visaType,
    required this.educationDetails,
    required this.createdBy,
    required this.createdAt,
    required this.pivot,
    required this.metaData,*/ /*

  });

  int id;
  int designationId;
  String firstName;
  String lastName;
  String email;
  */
/*dynamic dob;
  int phone;
  int reportingPerson;
  dynamic atContact;
  String address;
  String oldPassword;
  String deviceToken;
  String userProfile;
  dynamic deviceId;
  int isExcluded;
  int permissionMenu;
  dynamic dataOfJoining;
  dynamic bloodGroup;
  dynamic emergencyContactNumber;
  dynamic emergencyContactName;
  String emergencyContactRelationship;
  dynamic addressInUae;
  dynamic nationality;
  dynamic medicalConditions;
  String maritalStatus;
  dynamic visaType;
  String educationDetails;
  dynamic createdBy;
  DateTime createdAt;
  Pivot pivot;
  MetaData metaData;*/ /*


  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["id"],
        designationId: json["designation_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        */
/*dob: json["dob"],
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
        emergencyContactRelationship: json["emergency_contact_relationship"],
        addressInUae: json["address_in_uae"],
        nationality: json["nationality"],
        medicalConditions: json["medical_conditions"],
        maritalStatus: json["marital_status"],
        visaType: json["visa_type"],
        educationDetails: json["education_details"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
        metaData: MetaData.fromJson(json["meta_data"]),*/ /*

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "designation_id": designationId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
       */
/* "dob": dob,
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
        "emergency_contact_relationship": emergencyContactRelationship,
        "address_in_uae": addressInUae,
        "nationality": nationality,
        "medical_conditions": medicalConditions,
        "marital_status": maritalStatus,
        "visa_type": visaType,
        "education_details": educationDetails,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "pivot": pivot.toJson(),
        "meta_data": metaData.toJson(),*/ /*

      };
}

class MetaData {
  MetaData({
    required this.indianNumber,
    required this.personalEmail,
    required this.emergencyNumber,
    required this.passportNumber,
    required this.passportExpiryDate,
    required this.visaNumber,
    required this.visaExpiryDate,
    required this.bankName,
    required this.bankIfsc,
    required this.accountNumber,
    required this.dob,
    required this.bloodGroup,
    required this.dataOfJoining,
    required this.addressInUae,
    required this.emergencyContactName,
    required this.emergencyContactRelationship,
    required this.nationality,
    required this.medicalConditions,
    required this.maritalStatus,
    required this.visaType,
    required this.educationDetails,
  });

  String indianNumber;
  dynamic personalEmail;
  dynamic emergencyNumber;
  dynamic passportNumber;
  dynamic passportExpiryDate;
  dynamic visaNumber;
  dynamic visaExpiryDate;
  dynamic bankName;
  dynamic bankIfsc;
  dynamic accountNumber;
  dynamic dob;
  dynamic bloodGroup;
  dynamic dataOfJoining;
  dynamic addressInUae;
  dynamic emergencyContactName;
  String emergencyContactRelationship;
  dynamic nationality;
  dynamic medicalConditions;
  String maritalStatus;
  dynamic visaType;
  String educationDetails;

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        indianNumber: json["indian_number"],
        personalEmail: json["personal_email"],
        emergencyNumber: json["emergency_number"],
        passportNumber: json["passport_number"],
        passportExpiryDate: json["passport_expiry_date"],
        visaNumber: json["visa_number"],
        visaExpiryDate: json["visa_expiry_date"],
        bankName: json["bank_name"],
        bankIfsc: json["bank_ifsc"],
        accountNumber: json["account_number"],
        dob: json["dob"],
        bloodGroup: json["blood_group "],
        dataOfJoining: json["data_of_joining "],
        addressInUae: json["address_in_uae"],
        emergencyContactName: json["emergency_contact_name"],
        emergencyContactRelationship: json["emergency_contact_relationship"],
        nationality: json["nationality"],
        medicalConditions: json["medical_conditions"],
        maritalStatus: json["marital_status"],
        visaType: json["visa_type"],
        educationDetails: json["education_details"],
      );

  Map<String, dynamic> toJson() => {
        "indian_number": indianNumber,
        "personal_email": personalEmail,
        "emergency_number": emergencyNumber,
        "passport_number": passportNumber,
        "passport_expiry_date": passportExpiryDate,
        "visa_number": visaNumber,
        "visa_expiry_date": visaExpiryDate,
        "bank_name": bankName,
        "bank_ifsc": bankIfsc,
        "account_number": accountNumber,
        "dob": dob,
        "blood_group ": bloodGroup,
        "data_of_joining ": dataOfJoining,
        "address_in_uae": addressInUae,
        "emergency_contact_name": emergencyContactName,
        "emergency_contact_relationship": emergencyContactRelationship,
        "nationality": nationality,
        "medical_conditions": medicalConditions,
        "marital_status": maritalStatus,
        "visa_type": visaType,
        "education_details": educationDetails,
      };
}

class NewComment {
  NewComment({
    required this.id,
    required this.leadId,
    required this.agentId,
    required this.date,
    required this.time,
    required this.newComments,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  int? leadId;
  int? agentId;
  DateTime date;
  String? time;
  String? newComments;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NewComment.fromJson(Map<String, dynamic> json) => NewComment(
        id: json["id"],
        leadId: json["lead_id"],
        agentId: json["agent_id"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        newComments: json["new_comments"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "agent_id": agentId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "new_comments": newComments,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Note {
  Note({
    required this.id,
    required this.relId,
    required this.relType,
    required this.description,
    required this.dateContacted,
    required this.addedfrom,
    required this.dateadded,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int relId;
  String relType;
  String description;
  dynamic dateContacted;
  int addedfrom;
  DateTime dateadded;
  DateTime createdAt;
  DateTime updatedAt;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        relId: json["rel_id"],
        relType: json["rel_type"],
        description: json["description"],
        dateContacted: json["date_contacted"],
        addedfrom: json["addedfrom"],
        dateadded: DateTime.parse(json["dateadded"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rel_id": relId,
        "rel_type": relType,
        "description": description,
        "date_contacted": dateContacted,
        "addedfrom": addedfrom,
        "dateadded": dateadded.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

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
  Developer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String phone;
  String address;
  DateTime createdAt;
  DateTime updatedAt;

  factory Developer.fromJson(Map<String, dynamic> json) => Developer(
        id: json["id"],
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
    required this.createdAt,
    required this.updatedAt,
    required this.ameneties,
  });

  int id;
  String name;
  String slug;
  dynamic description;
  int cityId;
  String address;
  int developerId;
  String budget;
  String image;
  String featuredProperty;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> ameneties;

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        cityId: json["city_id"],
        address: json["address"],
        developerId: json["developer_id"],
        budget: json["budget"],
        image: json["image"],
        featuredProperty: json["featured_property"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        ameneties: List<dynamic>.from(json["ameneties"].map((x) => x)),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "ameneties": List<dynamic>.from(ameneties.map((x) => x)),
      };
}

class Sources {
  Sources({
    required this.id,
    required this.name,
    required this.status,
   */
/* required this.createdAt,
    required this.updatedAt,*/ /*

  });

  int? id;
  String? name;
  String? status;
  */
/*DateTime? createdAt;
  DateTime? updatedAt;*/ /*


  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        */
/*createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),*/ /*

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        */
/*"created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),*/ /*

      };
}

class Statuses {
  Statuses({
    required this.id,
    required this.name,
    //   required this.statusorder,
    required this.color,
    required this.isdefault,
    //required this.createdAt,
    //required this.updatedAt,
  });

  int id;
  String name;

  // int statusorder;
  String color;
  int isdefault;
  //DateTime createdAt;
  //DateTime updatedAt;

  factory Statuses.fromJson(Map<String, dynamic> json) => Statuses(
        id: json["id"],
        name: json["name"],
        //   statusorder: json["statusorder"] == null ? null : json["statusorder"],
        color: json["color"],
        isdefault: json["isdefault"],
        //createdAt: DateTime.parse(json["created_at"]),
        //updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        //  "statusorder": statusorder == null ? null : statusorder,
        "color": color,
        "isdefault": isdefault,
        //"created_at": createdAt.toIso8601String(),
        //"updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
*/

import 'dart:convert';

import 'package:crm_application/Models/LeadInfoModel.dart';
import 'package:intl/intl.dart';

LeadsModel leadsModelFromJson(String str) =>
    LeadsModel.fromJson(json.decode(str));

String leadsModelToJson(LeadsModel data) => json.encode(data.toJson());

class LeadsModel {
  LeadsModel({
    required this.success,
    required this.count,
    required this.data,
    required this.message,
  });

  int success;
  int count;
  Data data;
  String message;

  factory LeadsModel.fromJson(Map<String, dynamic> json) => LeadsModel(
        success: json["success"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int currentPage;
  List<Lead> data;
  var firstPageUrl;
  int from;
  int lastPage;
  var lastPageUrl;
  var nextPageUrl;
  var path;
  var perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Lead>.from(json["data"].map((x) => Lead.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Lead {
  Lead({
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
    //required this.additionalComment,
    //required this.customerId,
    //    required this.developerId,
    //    required this.propertyId,
    //    required this.propertyPreference,
    //    required this.jobProfile,
    required this.avgIncome,
    //    required this.status,
    //    required this.attachment,
    //    required this.type,
    required this.amount,
    //    required this.closedDate,
    //    required this.closeBy,
    required this.leadId,
    //   required  this.agentId,
    //    required this.review,
    //    required this.createdBy,
    //    required this.assignLeadsCount,
    //    required this.customer,
    //    //required this.developer,
    // //   required this.property,
    required this.agents,
    required this.statuses,
    //    required this.leadUser,
    required this.sources,
    //required this.notes,
    required this.newComments,
  });

  int id;
  String name;
  String? email;
  String phone;
  String? altPhone;
  DateTime date;
  String? dob;

  String? source;
  String? priority;
  String? comment;

//   dynamic additionalComment;
//   dynamic customerId;
//   int? developerId;
//   int? propertyId;
//   dynamic propertyPreference;
//   dynamic jobProfile;
  String? avgIncome;

//   int? status;
//   dynamic attachment;
//   String? type;
  String? amount;

//   DateTime closedDate;
//   int? closeBy;
  int? leadId;
//   int? agentId;
//   dynamic review;
//   int? createdBy;
//   int? assignLeadsCount;
//   dynamic customer;
//   //Developer? developer;
// //  Property property;
  List<Agent>? agents;
  Statuses? statuses;
//   Datum leadUser;
  Sources? sources;

  //List<Note> notes;
  List<NewComment>? newComments;

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
        id: json["id"].runtimeType == 0.runtimeType
            ? json["id"]
            : int.parse(json["id"]),
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        altPhone: json["alt_phone"] ?? 'No Alternate Number',
        date: DateTime.parse(json["date"]),
        dob: json["dob"],
        source: json["source"],
        priority: json["priority"],
        comment: json["comment"],
//    additionalComment: json["additional_comment"],
//     customerId: json["customer_id"],
//     developerId:  json["developer_id"],
//     propertyId:  json["property_id"],
//     propertyPreference: json["property_preference"],
//     jobProfile: json["job_profile"],
        avgIncome: json["avg_income"] ?? 'No Data Available',
//     status: json["status"],
//     attachment: json["attachment"],
//     type: json["type"],
        amount: json["amount"],
//     closedDate: DateTime.parse(json["closed_date"]),
//     closeBy: json["close_by"],
//         leadId: json["lead_id"],
        leadId: json["id"],
//     agentId:  json["agent_id"],
//     review: json["review"],
//     createdBy: json["created_by"],
//     assignLeadsCount: json["assign_leads_count"],
//     customer: json["customer"],
//     //developer:  Developer.fromJson(json["developer"]),
//    // property:  Property.fromJson(json["property"]),
        agents: json["agents"] != null
            ? List<Agent>.from(json["agents"].map((x) => Agent.fromJson(x)))
            : null,
        statuses: json["statuses"] != null
            ? Statuses.fromJson(json["statuses"])
            : null,
//     leadUser: Datum.fromJson(json["lead_user"]),
        sources: json["sources"] != null
            ? Sources.fromJson(json["sources"] ?? {})
            : null,
        //notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
        newComments: json["new_comments"] != null
            ? List<NewComment>.from(
                json["new_comments"].map((x) => NewComment.fromJson(x)))
            : null,
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
//     "additional_comment": additionalComment,
//     "customer_id": customerId,
//     "developer_id":  developerId,
//     "property_id":  propertyId,
//     "property_preference": propertyPreference,
//     "job_profile": jobProfile,
        "avg_income": avgIncome,
//     "status": status,
//     "attachment": attachment,
//     "type": type,
//     "amount": amount,
//     "closed_date": closedDate.toIso8601String(),
//     "close_by": closeBy,
        "lead_id": leadId,
//     "agent_id":  agentId,
//     "review": review,
//     "created_by": createdBy,
//     "assign_leads_count": assignLeadsCount,
//     "customer": customer,
//  //   "developer": developer?.toJson(),
// //    "property": property.toJson(),
        "agents": List<dynamic>.from(agents!.map((x) => x.toJson())),
        //"statuses": statuses.toJson(),
//     "lead_user": leadUser.toJson(),
        "sources": sources!.toJson(),
        // "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
        "new_comments": List<dynamic>.from(newComments!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.leadId,
    required this.userId,
    required this.lead,
  });

  int id;
  int leadId;
  int userId;
  Lead lead;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        leadId: json["lead_id"],
        userId: json["user_id"],
        lead: Lead.fromJson(json["lead"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "user_id": userId,
        "lead": lead.toJson(),
      };
}

class Agent {
  Agent({
    required this.id,
    required this.designationId,
    required this.firstName,
    required this.fullName,
    required this.lastName,
    required this.email,
    this.userProfile,
    required this.pivot,
    /*required this.dob,
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
    required this.emergencyContactRelationship,
    required this.addressInUae,
    required this.nationality,
    required this.medicalConditions,
    required this.maritalStatus,
    required this.visaType,
    required this.educationDetails,
    required this.createdBy,
    required this.createdAt,
    
    required this.metaData,*/
  });

  int id;
  int? designationId;
  String fullName;
  String firstName;
  String lastName;
  String? email;
  String? userProfile;
  Pivot? pivot;

  /*dynamic dob;
  int phone;
  int reportingPerson;
  dynamic atContact;
  String address;
  String oldPassword;
  String deviceToken;
  dynamic deviceId;
  int isExcluded;
  int permissionMenu;
  dynamic dataOfJoining;
  dynamic bloodGroup;
  dynamic emergencyContactNumber;
  dynamic emergencyContactName;
  String emergencyContactRelationship;
  dynamic addressInUae;
  dynamic nationality;
  dynamic medicalConditions;
  String maritalStatus;
  dynamic visaType;
  String educationDetails;
  dynamic createdBy;
  DateTime createdAt;
  
  MetaData metaData;*/

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json["id"],
      designationId: json["designation_id"],
      fullName: json["full_name"],
      firstName: json["first_name"],
      lastName: json["last_name"] ?? "",
      email: json["email"],
      userProfile: json["user_profile"],
      pivot: json["pivot"] != null ? Pivot.fromJson(json["pivot"]) : null,
      /*dob: json["dob"],
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
        emergencyContactRelationship: json["emergency_contact_relationship"],
        addressInUae: json["address_in_uae"],
        nationality: json["nationality"],
        medicalConditions: json["medical_conditions"],
        maritalStatus: json["marital_status"],
        visaType: json["visa_type"],
        educationDetails: json["education_details"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
        metaData: MetaData.fromJson(json["meta_data"]),*/
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "designation_id": designationId,
        "full_name": fullName,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "user_profile": userProfile,
        /* "dob": dob,
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
        "emergency_contact_relationship": emergencyContactRelationship,
        "address_in_uae": addressInUae,
        "nationality": nationality,
        "medical_conditions": medicalConditions,
        "marital_status": maritalStatus,
        "visa_type": visaType,
        "education_details": educationDetails,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "pivot": pivot.toJson(),
        "meta_data": metaData.toJson(),*/
      };
}

class MetaData {
  MetaData({
    required this.indianNumber,
    required this.personalEmail,
    required this.emergencyNumber,
    required this.passportNumber,
    required this.passportExpiryDate,
    required this.visaNumber,
    required this.visaExpiryDate,
    required this.bankName,
    required this.bankIfsc,
    required this.accountNumber,
    required this.dob,
    required this.bloodGroup,
    required this.dataOfJoining,
    required this.addressInUae,
    required this.emergencyContactName,
    required this.emergencyContactRelationship,
    required this.nationality,
    required this.medicalConditions,
    required this.maritalStatus,
    required this.visaType,
    required this.educationDetails,
  });

  String indianNumber;
  dynamic personalEmail;
  dynamic emergencyNumber;
  dynamic passportNumber;
  dynamic passportExpiryDate;
  dynamic visaNumber;
  dynamic visaExpiryDate;
  dynamic bankName;
  dynamic bankIfsc;
  dynamic accountNumber;
  dynamic dob;
  dynamic bloodGroup;
  dynamic dataOfJoining;
  dynamic addressInUae;
  dynamic emergencyContactName;
  String emergencyContactRelationship;
  dynamic nationality;
  dynamic medicalConditions;
  String maritalStatus;
  dynamic visaType;
  String educationDetails;

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        indianNumber: json["indian_number"],
        personalEmail: json["personal_email"],
        emergencyNumber: json["emergency_number"],
        passportNumber: json["passport_number"],
        passportExpiryDate: json["passport_expiry_date"],
        visaNumber: json["visa_number"],
        visaExpiryDate: json["visa_expiry_date"],
        bankName: json["bank_name"],
        bankIfsc: json["bank_ifsc"],
        accountNumber: json["account_number"],
        dob: json["dob"],
        bloodGroup: json["blood_group "],
        dataOfJoining: json["data_of_joining "],
        addressInUae: json["address_in_uae"],
        emergencyContactName: json["emergency_contact_name"],
        emergencyContactRelationship: json["emergency_contact_relationship"],
        nationality: json["nationality"],
        medicalConditions: json["medical_conditions"],
        maritalStatus: json["marital_status"],
        visaType: json["visa_type"],
        educationDetails: json["education_details"],
      );

  Map<String, dynamic> toJson() => {
        "indian_number": indianNumber,
        "personal_email": personalEmail,
        "emergency_number": emergencyNumber,
        "passport_number": passportNumber,
        "passport_expiry_date": passportExpiryDate,
        "visa_number": visaNumber,
        "visa_expiry_date": visaExpiryDate,
        "bank_name": bankName,
        "bank_ifsc": bankIfsc,
        "account_number": accountNumber,
        "dob": dob,
        "blood_group ": bloodGroup,
        "data_of_joining ": dataOfJoining,
        "address_in_uae": addressInUae,
        "emergency_contact_name": emergencyContactName,
        "emergency_contact_relationship": emergencyContactRelationship,
        "nationality": nationality,
        "medical_conditions": medicalConditions,
        "marital_status": maritalStatus,
        "visa_type": visaType,
        "education_details": educationDetails,
      };
}

class NewComment {
  NewComment({
    required this.id,
    required this.leadId,
    required this.agentId,
    required this.date,
    required this.time,
    required this.newComments,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  int? leadId;
  int? agentId;
  DateTime date;
  String? time;
  String? newComments;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NewComment.fromJson(Map<String, dynamic> json) => NewComment(
        id: json["id"],
        leadId: json["lead_id"],
        agentId: json["agent_id"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        newComments: json["new_comments"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "agent_id": agentId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "new_comments": newComments,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Note {
  Note({
    required this.id,
    required this.relId,
    required this.relType,
    required this.description,
    required this.dateContacted,
    required this.addedfrom,
    required this.dateadded,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int relId;
  String relType;
  String description;
  dynamic dateContacted;
  int addedfrom;
  DateTime dateadded;
  DateTime createdAt;
  DateTime updatedAt;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        relId: json["rel_id"],
        relType: json["rel_type"],
        description: json["description"],
        dateContacted: json["date_contacted"],
        addedfrom: json["addedfrom"],
        dateadded: DateTime.parse(json["dateadded"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rel_id": relId,
        "rel_type": relType,
        "description": description,
        "date_contacted": dateContacted,
        "addedfrom": addedfrom,
        "dateadded": dateadded.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Pivot {
  Pivot({
    required this.leadId,
    required this.userId,
    required this.isAccepted,
  });

  int leadId;
  int userId;
  int isAccepted;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        leadId: json["lead_id"] ?? 0,
        userId: json["user_id"] ?? 0,
        isAccepted: json["isAccepted"] ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {"lead_id": leadId, "user_id": userId, "isAccepted": isAccepted};
}

class Developer {
  Developer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String phone;
  String address;
  DateTime createdAt;
  DateTime updatedAt;

  factory Developer.fromJson(Map<String, dynamic> json) => Developer(
        id: json["id"],
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
    required this.createdAt,
    required this.updatedAt,
    required this.ameneties,
  });

  int id;
  String name;
  String slug;
  dynamic description;
  int cityId;
  String address;
  int developerId;
  String budget;
  String image;
  String featuredProperty;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> ameneties;

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        cityId: json["city_id"],
        address: json["address"],
        developerId: json["developer_id"],
        budget: json["budget"],
        image: json["image"],
        featuredProperty: json["featured_property"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        ameneties: List<dynamic>.from(json["ameneties"].map((x) => x)),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "ameneties": List<dynamic>.from(ameneties.map((x) => x)),
      };
}

class Sources {
  Sources({
    required this.id,
    required this.name,
    required this.status,
    /* required this.createdAt,
    required this.updatedAt,*/
  });

  //int? id;
  var id;
  //String? name;
  var name;
  var status;
  /*DateTime? createdAt;
  DateTime? updatedAt;*/

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        /*createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),*/
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        /*"created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),*/
      };
}

class Statuses {
  Statuses({
    required this.id,
    required this.name,
    //   required this.statusorder,
    required this.color,
    required this.isdefault,
    //required this.createdAt,
    //required this.updatedAt,
  });

  int id;
  String name;

  // int statusorder;
  String color;
  int isdefault;
  //DateTime createdAt;
  //DateTime updatedAt;

  factory Statuses.fromJson(Map<String, dynamic> json) => Statuses(
        id: json["id"],
        name: json["name"],
        //   statusorder: json["statusorder"] == null ? null : json["statusorder"],
        color: json["color"],
        isdefault: json["isdefault"],
        //createdAt: DateTime.parse(json["created_at"]),
        //updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        //  "statusorder": statusorder == null ? null : statusorder,
        "color": color,
        "isdefault": isdefault,
        //"created_at": createdAt.toIso8601String(),
        //"updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class LeadsByDate {
  LeadsByDate({
    this.date,
    this.leads,
  });

  String? date;
  List<Lead>? leads;
}
