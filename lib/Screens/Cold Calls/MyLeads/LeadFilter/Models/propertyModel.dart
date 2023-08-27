import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/developerModel.dart';

class PropertyModel {
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
  String? createdAt;
  String? updatedAt;
  // List? ameneties;
  // DeveloperModel? developer;
  // City? city;

  PropertyModel(
      {this.id,
        this.name,
        this.slug,
        this.description,
        this.cityId,
        this.address,
        this.developerId,
        this.budget,
        this.image,
        this.featuredProperty,
        this.createdAt,
        this.updatedAt,
        // this.ameneties,
        // this.developer,
        // this.city,
      });

  PropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    cityId = json['city_id'];
    address = json['address'];
    developerId = json['developer_id'];
    budget = json['budget'];
    image = json['image'];
    featuredProperty = json['featured_property'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // if (json['ameneties'] != null) {
    //   ameneties = <String>[];
    //   json['ameneties'].forEach((v) {
    //     ameneties!.add(v);
    //   });
    // }
    // developer = json['developer'] != null
    //     ? DeveloperModel.fromJson(json['developer'])
    //     : null;
    // city = json['city'] != null ? City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['city_id'] = cityId;
    data['address'] = address;
    data['developer_id'] = developerId;
    data['budget'] = budget;
    data['image'] = image;
    data['featured_property'] = featuredProperty;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    // if (ameneties != null) {
    //   data['ameneties'] = ameneties!.map((v) => v.toJson()).toList();
    // }
    // if (developer != null) {
    //   data['developer'] = developer!.toJson();
    // }
    // if (city != null) {
    //   data['city'] = city!.toJson();
    // }
    return data;
  }
}



class City {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  City({this.id, this.name, this.createdAt, this.updatedAt});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}