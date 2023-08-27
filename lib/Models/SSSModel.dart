import 'package:crm_application/Models/Surveydata.dart';
import 'package:intl/intl.dart';

class SSSModel {
  int? id;
  int? leadId;
  String? fname;
  String? forename;
  String? surname;
  String? passportNumber;
  String? nationality;
  String? birthCountry;
  String? otherNationality;
  String? otherCountry;
  String? otherPassportNumber;
  String? expiryPassportDate;
  String? occupation;
  String? jobCompanyName;
  String? jobCountryName;
  String? jobPosition;
  String? businessCompanyName;
  String? businessCountryName;
  String? businessEntityType;
  String? businessNature;
  String? businessCountryWith;
  String? phone;
  String? email;
  String? address1;
  String? address2;
  String? city;
  String? pincode;
  String? onboardingDate;
  String? agentName;
  int? agentId;
  String? signature;
  String? dateOfClientMeeting;
  String? clientIntroduced;
  String? modeOfPayment;
  String? unitNo;
  String? developerName;
  String? propertyValue;
  String? sowSof;
  String? otherOccupation;
  String? dob;
  String? commission;
  String? passportExpiryDate;
  String? createdAt;
  String? updatedAt;
  SurveyData? surveyData;

  SSSModel(
      {this.id,
        this.leadId,
        this.fname,
        this.forename,
        this.surname,
        this.passportNumber,
        this.nationality,
        this.birthCountry,
        this.otherNationality,
        this.otherCountry,
        this.otherPassportNumber,
        this.expiryPassportDate,
        this.occupation,
        this.jobCompanyName,
        this.jobCountryName,
        this.jobPosition,
        this.businessCompanyName,
        this.businessCountryName,
        this.businessEntityType,
        this.businessNature,
        this.businessCountryWith,
        this.phone,
        this.email,
        this.address1,
        this.address2,
        this.city,
        this.pincode,
        this.onboardingDate,
        this.agentName,
        this.agentId,
        this.signature,
        this.dateOfClientMeeting,
        this.clientIntroduced,
        this.modeOfPayment,
        this.unitNo,
        this.developerName,
        this.propertyValue,
        this.sowSof,
        this.otherOccupation,
        this.dob,
        this.commission,
        this.passportExpiryDate,
        this.createdAt,
        this.updatedAt,
        this.surveyData});

  SSSModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    fname = json['fname'];
    forename = json['forename'];
    surname = json['surname'];
    passportNumber = json['passport_number'];
    nationality = json['nationality'];
    birthCountry = json['birth_country'];
    otherNationality = json['other_nationality'];
    otherCountry = json['other_country'];
    otherPassportNumber = json['other_passport_number'];
    expiryPassportDate = json['expiry_passport_date'];
    occupation = json['occupation'];
    jobCompanyName = json['job_company_name'];
    jobCountryName = json['job_country_name'];
    jobPosition = json['job_position'];
    businessCompanyName = json['business_company_name'];
    businessCountryName = json['business_country_name'];
    businessEntityType = json['business_entity_type'];
    businessNature = json['business_nature'];
    businessCountryWith = json['business_country_with'];
    phone = json['phone'];
    email = json['email'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    pincode = json['pincode'];
    onboardingDate = json['onboarding_date'];
    agentName = json['agent_name'];
    agentId = json['agent_id'];
    signature = json['signature'];
    dateOfClientMeeting = json['date_of_client_meeting'];
    clientIntroduced = json['client_introduced'];
    modeOfPayment = json['mode_of_payment'];
    unitNo = json['unit_no'];
    developerName = json['developer_name'];
    propertyValue = json['property_value'];
    sowSof = json['sow_sof'];
    otherOccupation = json['other_occupation'];
    dob = json['dob'];
    commission = json['commission'];
    passportExpiryDate = json['passport_expiry_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    surveyData = json['sss'] != null ? SurveyData.fromJson(json['sss']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lead_id'] = leadId;
    data['fname'] = fname;
    data['forename'] = forename;
    data['surname'] = surname;
    data['passport_number'] = passportNumber;
    data['nationality'] = nationality;
    data['birth_country'] = birthCountry;
    data['other_nationality'] = otherNationality;
    data['other_country'] = otherCountry;
    data['other_passport_number'] = otherPassportNumber;
    data['expiry_passport_date'] = expiryPassportDate;
    data['occupation'] = occupation;
    data['job_company_name'] = jobCompanyName;
    data['job_country_name'] = jobCountryName;
    data['job_position'] = jobPosition;
    data['business_company_name'] = businessCompanyName;
    data['business_country_name'] = businessCountryName;
    data['business_entity_type'] = businessEntityType;
    data['business_nature'] = businessNature;
    data['business_country_with'] = businessCountryWith;
    data['phone'] = phone;
    data['email'] = email;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['pincode'] = pincode;
    data['onboarding_date'] = onboardingDate;
    data['agent_name'] = agentName;
    data['agent_id'] = agentId;
    data['signature'] = signature;
    data['date_of_client_meeting'] = dateOfClientMeeting;
    data['client_introduced'] = clientIntroduced;
    data['mode_of_payment'] = modeOfPayment;
    data['unit_no'] = unitNo;
    data['developer_name'] = developerName;
    data['property_value'] = propertyValue;
    data['sow_sof'] = sowSof;
    data['other_occupation'] = otherOccupation;
    data['dob'] = dob;
    data['commission'] = commission;
    data['passport_expiry_date'] = passportExpiryDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (surveyData != null) {
      data['sss'] = surveyData!.toJson();
    }
    return data;
  }
}



class SSSByDate {
  SSSByDate({
    this.date,
    this.sss,
  });

  String? date;
  List<SSSModel>? sss;
}

String dateFormatting(String date) {
  var dateTime;
  try {
    dateTime = DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
    return dateTime;
  } on FormatException catch (e) {
    var splited = date.split('/');
    var joined = '${splited[2]}-${splited[0]}-${splited[1]}';

    dateTime = DateFormat('yyyy-MM-dd').format(DateTime.parse(joined));
    print(e);
    return dateTime;
  }
}
