class StatusModel {
  int? id;
  String? name;
  int? statusorder;
  String? color;
  int? isdefault;
  String? createdAt;
  String? updatedAt;

  StatusModel(
      {this.id,
        this.name,
        this.statusorder,
        this.color,
        this.isdefault,
        this.createdAt,
        this.updatedAt});

  StatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    statusorder = json['statusorder'];
    color = json['color'];
    isdefault = json['isdefault'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['statusorder'] = statusorder;
    data['color'] = color;
    data['isdefault'] = isdefault;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
class ColdCallStatus {
  int? id;
  String? name;
  int? statusorder;
  String? color;
  int? isdefault;
  String? createdAt;
  String? updatedAt;

  ColdCallStatus(
      {this.id,
        this.name,
        this.statusorder,
        this.color,
        this.isdefault,
        this.createdAt,
        this.updatedAt});

  ColdCallStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    statusorder = json['statusorder'];
    color = json['color'];
    isdefault = json['isdefault'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['statusorder'] = statusorder;
    data['color'] = color;
    data['isdefault'] = isdefault;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}