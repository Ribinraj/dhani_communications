class MachineHireModel {
  final String? hireId;
  final String? userId;
  final String? projectId;
  final String? machineryId;
  final String? hireDate;
  final String? fromTime;
  final String? toTime;
  final String? totalHours;
  final String? amountPaid;
  final String? status;
  final String? notes;
  final String? approver;
  final String? approverRemarks;
  final String? updatedBy;
  final CreatedAt? createdAt;
  final String? modifiedAt;
  final String? projectName;
  final String? machine;

  MachineHireModel({
    this.hireId,
    this.userId,
    this.projectId,
    this.machineryId,
    this.hireDate,
    this.fromTime,
    this.toTime,
    this.totalHours,
    this.amountPaid,
    this.status,
    this.notes,
    this.approver,
    this.approverRemarks,
    this.updatedBy,
    this.createdAt,
    this.modifiedAt,
    this.projectName,
    this.machine,
  });

  factory MachineHireModel.fromJson(Map<String, dynamic> json) {
    return MachineHireModel(
      hireId: json['hireId']?.toString(),
      userId: json['userId']?.toString(),
      projectId: json['projectId']?.toString(),
      machineryId: json['machineryId']?.toString(),
      hireDate: json['hireDate']?.toString(),
      fromTime: json['fromTime']?.toString(),
      toTime: json['toTime']?.toString(),
      totalHours: json['totalHours']?.toString(),
      amountPaid: json['amountPaid']?.toString(),
      status: json['status']?.toString(),
      notes: json['notes']?.toString(),
      approver: json['approver']?.toString(),
      approverRemarks: json['approverRemarks']?.toString(),
      updatedBy: json['updatedBy']?.toString(),
      createdAt: json['created_at'] != null
          ? CreatedAt.fromJson(json['created_at'])
          : null,
      modifiedAt: json['modified_at']?.toString(),
      projectName: json['projectName']?.toString(),
      machine: json['machine']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hireId': hireId,
      'userId': userId,
      'projectId': projectId,
      'machineryId': machineryId,
      'hireDate': hireDate,
      'fromTime': fromTime,
      'toTime': toTime,
      'totalHours': totalHours,
      'amountPaid': amountPaid,
      'status': status,
      'notes': notes,
      'approver': approver,
      'approverRemarks': approverRemarks,
      'updatedBy': updatedBy,
      'created_at': createdAt?.toJson(),
      'modified_at': modifiedAt,
      'projectName': projectName,
      'machine': machine,
    };
  }
}

class CreatedAt {
  final String? date;
  final int? timezoneType;
  final String? timezone;

  CreatedAt({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  factory CreatedAt.fromJson(Map<String, dynamic> json) {
    return CreatedAt(
      date: json['date']?.toString(),
      timezoneType: json['timezone_type'],
      timezone: json['timezone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'timezone_type': timezoneType,
      'timezone': timezone,
    };
  }
}