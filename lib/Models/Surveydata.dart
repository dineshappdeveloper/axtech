class SurveyData {
  int? id;
  int? leadId;
  String? topBoxRate;
  String? netPromoterRate;
  String? currentAddress;
  String? propertyBeingUsed;
  String? rangeProperty;
  String? nameOne;
  String? emailOne;
  String? contactOne;
  String? nameTwo;
  String? emailTwo;
  String? contactTwo;
  String? comments;
  String? createdAt;
  String? updatedAt;

  SurveyData(
      {this.id,
        this.leadId,
        this.topBoxRate,
        this.netPromoterRate,
        this.currentAddress,
        this.propertyBeingUsed,
        this.rangeProperty,
        this.nameOne,
        this.emailOne,
        this.contactOne,
        this.nameTwo,
        this.emailTwo,
        this.contactTwo,
        this.comments,
        this.createdAt,
        this.updatedAt});

  SurveyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    topBoxRate = json['top_box_rate'];
    netPromoterRate = json['net_promoter_rate'];
    currentAddress = json['current_address'];
    propertyBeingUsed = json['property_being_used'];
    rangeProperty = json['range_property'];
    nameOne = json['name_one'];
    emailOne = json['email_one'];
    contactOne = json['contact_one'];
    nameTwo = json['name_two'];
    emailTwo = json['email_two'];
    contactTwo = json['contact_two'];
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['top_box_rate'] = this.topBoxRate;
    data['net_promoter_rate'] = this.netPromoterRate;
    data['current_address'] = this.currentAddress;
    data['property_being_used'] = this.propertyBeingUsed;
    data['range_property'] = this.rangeProperty;
    data['name_one'] = this.nameOne;
    data['email_one'] = this.emailOne;
    data['contact_one'] = this.contactOne;
    data['name_two'] = this.nameTwo;
    data['email_two'] = this.emailTwo;
    data['contact_two'] = this.contactTwo;
    data['comments'] = this.comments;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}