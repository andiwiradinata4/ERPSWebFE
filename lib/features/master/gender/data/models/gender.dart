import 'package:erps/core/models/base.dart';

class Gender extends Base {
  final int id;
  final String description;
  final int statusID;

  Gender({this.id = 0, required this.description, required this.statusID});

  factory Gender.fromJson(Map<String, dynamic> json) {
    Gender data = Gender(
      id: json['ID'] ?? 0,
      description: json['Description'] ?? '',
      statusID: json['StatusID'] ?? 0,
    );

    data.remarks = json['Remarks'] ?? '';
    data.createdBy = json['CreatedBy'] ?? '';
    data.createdDate = json['CreatedDate'] ?? DateTime.now();
    data.logBy = json['LogBy'] ?? '';
    data.logDate = json['LogDate'] ?? DateTime.now();
    data.logInc = json['LogInc'] ?? 0;
    return data;
  }

  Map<String, dynamic> toJson() => {
    'ID': id,
    'Description': description,
    'StatusID': statusID,
    'Remarks': remarks,
    'CreatedBy': createdBy,
    'CreatedDate': createdDate,
    'LogBy': logBy,
    'LogDate': logDate,
    'LogInc': logInc,
  };
}
