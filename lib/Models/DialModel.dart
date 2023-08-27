import 'package:crm_application/Models/LeadsModel.dart';

class DialModel {
   int? id;
   int callId;
   String type;
   String? name;
   String startTime;
   String endTime;
   int connected;
   int status;
   String createdAt;

  DialModel({
    this.id,
    required this.callId,
    required this.type,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.connected,
    required this.status,
    required this.createdAt,
  });

  factory DialModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DialModel(
      id: json['id']!,
      callId: json['callId']!,
      type: json['type']!,
      name: json['name'],
      startTime: json['start_time']!,
      status: json['status']!,
      endTime: json['end_time']!,
      connected: json['connected']!,
      createdAt: json['createdAt']!,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['callId'] = callId;
    data['type'] = type;
    data['name'] = name;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['connected'] = connected;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
