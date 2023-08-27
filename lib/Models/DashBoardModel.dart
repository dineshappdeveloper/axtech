// To parse this JSON data, do
//
//     final dashBoardModel = dashBoardModelFromJson(jsonString);

import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) => DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  DashBoardModel({
    required this.success,
    required this.totColdCall,
    required this.totLeads,
    required this.totProperties,
    required this.featuredProperties,
    required this.message,
  });

  int success;
  int totColdCall;
  int totLeads;
  int totProperties;
  List<FeaturedProperty> featuredProperties;
  String message;

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
    success: json["success"],
    totColdCall: json["tot_cold_call"],
    totLeads: json["tot_leads"],
    totProperties: json["tot_properties"],
    featuredProperties: List<FeaturedProperty>.from(json["featured_properties"].map((x) => FeaturedProperty.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "tot_cold_call": totColdCall,
    "tot_leads": totLeads,
    "tot_properties": totProperties,
    "featured_properties": List<dynamic>.from(featuredProperties.map((x) => x.toJson())),
    "message": message,
  };
}

class FeaturedProperty {
  FeaturedProperty({
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
    required this.developer,
    required this.city,
  });

  int id;
  String name;
  String slug;
  String description;
  int cityId;
  String? address;
  int developerId;
  String budget;
  String image;
  String featuredProperty;
  DateTime createdAt;
  DateTime updatedAt;
  List<City> ameneties;
  Developer developer;
  City city;

  factory FeaturedProperty.fromJson(Map<String, dynamic> json) => FeaturedProperty(
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
    ameneties: List<City>.from(json["ameneties"].map((x) => City.fromJson(x))),
    developer: Developer.fromJson(json["developer"]),
    city: City.fromJson(json["city"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "city_id": cityId,
    "address":  address,
    "developer_id": developerId,
    "budget": budget,
    "image": image,
    "featured_property": featuredProperty,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "ameneties": List<dynamic>.from(ameneties.map((x) => x.toJson())),
    "developer": developer.toJson(),
    "city": city.toJson(),
  };
}

class City {
  City({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    //required this.pivot,
  });

  int? id;
  String? name;
  String createdAt;
  String updatedAt;
  //Pivot? pivot;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    //pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    //"pivot":  pivot!.toJson(),
  };
}

class Pivot {
  Pivot({
    required this.projectId,
    required this.amenetyId,
  });

  int? projectId;
  int? amenetyId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    projectId: json["project_id"],
    amenetyId: json["amenety_id"],
  );

  Map<String, dynamic> toJson() => {
    "project_id": projectId,
    "amenety_id": amenetyId,
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
