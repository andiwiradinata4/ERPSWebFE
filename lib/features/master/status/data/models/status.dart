import 'package:erps/core/models/base.dart';

class Status extends Base {
  final int id;
  final String description;
  final bool isActive;

  Status({this.id = 0, required this.description, this.isActive = true});

  factory Status.fromJson(Map<String, dynamic> json) {
    Status data = Status(
      id: json['ID'] ?? 0,
      description: json['Description'] ?? '',
      isActive: json['IsActive'] ?? false,
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
        'IsActive': isActive,
        'Remarks': remarks,
        'CreatedBy': createdBy,
        'CreatedDate': createdDate,
        'LogBy': logBy,
        'LogDate': logDate,
        'LogInc': logInc
      };
}
