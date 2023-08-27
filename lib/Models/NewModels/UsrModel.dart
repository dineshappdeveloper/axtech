class UserModel {
  String? token;
  String? tokenType;
  String? expiresAt;
  String? role;
  Data? data;

  UserModel({this.token, this.tokenType, this.expiresAt, this.role, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
    role = json['role'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    data['role'] = role;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? designationId;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;
  int? phone;
  int? reportingPerson;
  String? atContact;
  String? address;
  String? oldPassword;
  String? deviceToken;
  String? userProfile;
  String? status;
  String? availability;
  String? deviceId;
  int? isExcluded;
  int? permissionMenu;
  int? permissionForCl;
  String? dataOfJoining;
  String? bloodGroup;
  String? emergencyContactNumber;
  String? emergencyContactName;
  String? emergencyContactRelationship;
  String? addressInUae;
  String? nationality;
  String? medicalConditions;
  String? maritalStatus;
  String? visaType;
  String? educationDetails;
  int? companyId;
  String? createdBy;
  String? createdAt;
  MetaData? metaData;

  Data(
      {this.id,
      this.designationId,
      this.firstName,
      this.lastName,
      this.email,
      this.dob,
      this.phone,
      this.reportingPerson,
      this.atContact,
      this.address,
      this.oldPassword,
      this.deviceToken,
      this.userProfile,
      this.status,
      this.availability,
      this.deviceId,
      this.isExcluded,
      this.permissionMenu,
      this.permissionForCl,
      this.dataOfJoining,
      this.bloodGroup,
      this.emergencyContactNumber,
      this.emergencyContactName,
      this.emergencyContactRelationship,
      this.addressInUae,
      this.nationality,
      this.medicalConditions,
      this.maritalStatus,
      this.visaType,
      this.educationDetails,
      this.companyId,
      this.createdBy,
      this.createdAt,
      this.metaData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designationId = json['designation_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dob = json['dob'];
    phone = json['phone'];
    reportingPerson = json['reporting_person'];
    atContact = json['at_contact'];
    address = json['address'];
    oldPassword = json['old_password'];
    deviceToken = json['device_token'];
    userProfile = json['user_profile'];
    status = json['status'];
    availability = json['availability'];
    deviceId = json['device_id'];
    isExcluded = json['is_excluded'];
    permissionMenu = json['permission_menu'];
    permissionForCl = json['permission_for_cl'];
    dataOfJoining = json['data_of_joining'];
    bloodGroup = json['blood_group'];
    emergencyContactNumber = json['emergency_contact_number'];
    emergencyContactName = json['emergency_contact_name'];
    emergencyContactRelationship = json['emergency_contact_relationship'];
    addressInUae = json['address_in_uae'];
    nationality = json['nationality'];
    medicalConditions = json['medical_conditions'];
    maritalStatus = json['marital_status'];
    visaType = json['visa_type'];
    educationDetails = json['education_details'];
    companyId = json['company_id'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    metaData = json['meta_data'] != null
        ? MetaData.fromJson(json['meta_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['designation_id'] = designationId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['dob'] = dob;
    data['phone'] = phone;
    data['reporting_person'] = reportingPerson;
    data['at_contact'] = atContact;
    data['address'] = address;
    data['old_password'] = oldPassword;
    data['device_token'] = deviceToken;
    data['user_profile'] = userProfile;
    data['status'] = status;
    data['availability'] = availability;
    data['device_id'] = deviceId;
    data['is_excluded'] = isExcluded;
    data['permission_menu'] = permissionMenu;
    data['permission_for_cl'] = permissionForCl;
    data['data_of_joining'] = dataOfJoining;
    data['blood_group'] = bloodGroup;
    data['emergency_contact_number'] = emergencyContactNumber;
    data['emergency_contact_name'] = emergencyContactName;
    data['emergency_contact_relationship'] = emergencyContactRelationship;
    data['address_in_uae'] = addressInUae;
    data['nationality'] = nationality;
    data['medical_conditions'] = medicalConditions;
    data['marital_status'] = maritalStatus;
    data['visa_type'] = visaType;
    data['education_details'] = educationDetails;
    data['company_id'] = companyId;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    if (metaData != null) {
      data['meta_data'] = metaData!.toJson();
    }
    return data;
  }
}

class MetaData {
  String? indianNumber;
  String? personalEmail;
  String? emergencyNumber;
  String? passportNumber;
  String? passportExpiryDate;
  String? visaNumber;
  String? visaExpiryDate;
  String? bankName;
  String? bankIfsc;
  String? accountNumber;
  String? dob;
  String? bloodGroup;
  String? dataOfJoining;
  String? addressInUae;
  String? emergencyContactName;
  String? emergencyContactRelationship;
  String? nationality;
  String? medicalConditions;
  String? maritalStatus;
  String? visaType;
  String? educationDetails;

  MetaData({
    this.indianNumber,
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
    this.emergencyContactRelationship,
    this.nationality,
    this.medicalConditions,
    this.maritalStatus,
    this.visaType,
    this.educationDetails,
  });

  MetaData.fromJson(Map<String, dynamic> json) {
    indianNumber = json['indian_number'];
    personalEmail = json['personal_email'];
    emergencyNumber = json['emergency_number'];
    passportNumber = json['passport_number'];
    passportExpiryDate = json['passport_expiry_date'];
    visaNumber = json['visa_number'];
    visaExpiryDate = json['visa_expiry_date'];
    bankName = json['bank_name'];
    bankIfsc = json['bank_ifsc'];
    accountNumber = json['account_number'];
    dob = json['dob'];

    addressInUae = json['address_in_uae'];
    emergencyContactName = json['emergency_contact_name'];
    emergencyContactRelationship = json['emergency_contact_relationship'];
    nationality = json['nationality'];
    medicalConditions = json['medical_conditions'];
    maritalStatus = json['marital_status'];
    visaType = json['visa_type'];
    educationDetails = json['education_details'];
    bloodGroup = json['blood_group'];
    dataOfJoining = json['data_of_joining '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['indian_number'] = indianNumber;
    data['personal_email'] = personalEmail;
    data['emergency_number'] = emergencyNumber;
    data['passport_number'] = passportNumber;
    data['passport_expiry_date'] = passportExpiryDate;
    data['visa_number'] = visaNumber;
    data['visa_expiry_date'] = visaExpiryDate;
    data['bank_name'] = bankName;
    data['bank_ifsc'] = bankIfsc;
    data['account_number'] = accountNumber;
    data['dob'] = dob;

    data['address_in_uae'] = addressInUae;
    data['emergency_contact_name'] = emergencyContactName;
    data['emergency_contact_relationship'] = emergencyContactRelationship;
    data['nationality'] = nationality;
    data['medical_conditions'] = medicalConditions;
    data['marital_status'] = maritalStatus;
    data['visa_type'] = visaType;
    data['education_details'] = educationDetails;
    data['blood_group'] = bloodGroup;
    data['data_of_joining '] = dataOfJoining;
    return data;
  }
}
