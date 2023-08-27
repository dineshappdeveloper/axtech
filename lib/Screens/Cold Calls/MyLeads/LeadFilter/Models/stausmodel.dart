class SourceModel {
  int? id;
  String? name;
  int? status;
  int? isCroned;
  String? createdAt;
  String? updatedAt;

  SourceModel(
      {this.id,
        this.name,
        this.status,
        this.isCroned,
        this.createdAt,
        this.updatedAt});

  SourceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    isCroned = json['is_croned'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['is_croned'] = isCroned;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}