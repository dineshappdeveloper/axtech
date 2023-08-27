class DeveloperModel {
  int? id;
  String? name;
  String? phone;
  String? address;
  String? createdAt;
  String? updatedAt;

  DeveloperModel(
      {this.id,
        this.name,
        this.phone,
        this.address,
        this.createdAt,
        this.updatedAt});

  DeveloperModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}