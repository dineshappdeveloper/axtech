// To parse this JSON data, do
//
//     final agentListModel = agentListModelFromJson(jsonString);

import 'dart:convert';

AgentListModel agentListModelFromJson(String str) =>
    AgentListModel.fromJson(json.decode(str));

String agentListModelToJson(AgentListModel data) => json.encode(data.toJson());

class AgentListModel {
  AgentListModel({
    required this.agents,
    required this.keyword,
  });

  List<Agents> agents;
  String keyword;

  factory AgentListModel.fromJson(Map<String, dynamic> json) => AgentListModel(
        agents: List<Agents>.from(json["agents"].map((x) => Agents.fromJson(x))),
        keyword: json["keyword"],
      );

  Map<String, dynamic> toJson() => {
        "agents": List<dynamic>.from(agents.map((x) => x.toJson())),
        "keyword": keyword,
      };
}

class Agents {
  Agents({
    required this.id,
    required this.designationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.dob,
    required this.phone,
    required this.reportingPerson,
    this.atContact,
    required this.address,
    required this.oldPassword,
    required this.deviceToken,
    required this.userProfile,
    this.deviceId,
    required this.isExcluded,
    required this.permissionMenu,
    required this.permissionForCl,
    this.dataOfJoining,
    this.bloodGroup,
    this.emergencyContactNumber,
    this.emergencyContactName,
    required this.emergencyContactRelationship,
    this.addressInUae,
    this.nationality,
    this.medicalConditions,
    required this.maritalStatus,
    this.visaType,
    required this.educationDetails,
    this.createdBy,
   // required this.createdAt,
    //required this.metaData,
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
  int? permissionForCl;
  dynamic dataOfJoining;
  dynamic bloodGroup;
  dynamic emergencyContactNumber;
  dynamic emergencyContactName;
  String? emergencyContactRelationship;
  dynamic addressInUae;
  dynamic nationality;
  dynamic medicalConditions;
  String? maritalStatus;
  dynamic visaType;
  String? educationDetails;
  dynamic createdBy;
 // DateTime? createdAt;
  //MetaData metaData;

  factory Agents.fromJson(Map<String, dynamic> json) => Agents(
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
        permissionForCl: json["permission_for_cl"],
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
        //createdAt: DateTime.parse(json["created_at"]),
       // metaData: MetaData.fromJson(json["meta_data"]),
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
        "permission_for_cl": permissionForCl,
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
        //"created_at": createdAt.toIso8601String(),
        //"meta_data": metaData.toJson(),
      };
}

class MetaData {
  MetaData({
    required this.indianNumber,
    this.personalEmail,
    this.emergencyNumber,
    this.passportNumber,
    this.passportExpiryDate,
    this.visaNumber,
    this.visaExpiryDate,
    this.bankName,
    this.bankIfsc,
    this.accountNumber,
    this.dob,
    this.bloodGroup,
    this.dataOfJoining,
    this.addressInUae,
    this.emergencyContactName,
    required this.emergencyContactRelationship,
    this.nationality,
    this.medicalConditions,
    required this.maritalStatus,
    this.visaType,
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
