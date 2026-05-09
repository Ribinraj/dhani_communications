import 'package:dhani_communications/features/dashboard/models/machine_hire_model.dart';

class ApprovelsMachineHireModel {
  final String hireId;
  final String userId;
  final String projectId;
  final String machineryId;
  final String hireDate;
  final String fromTime;
  final String toTime;
  final String totalHours;
  final String amountPaid;
  final String status;
  final String notes;
  final String approver;
  final String? approverRemarks;
  final String? updatedBy;
  final CreatedAt? createdAt;
  final String modifiedAt;
  final String machine;

  ApprovelsMachineHireModel({
    required this.hireId,
    required this.userId,
    required this.projectId,
    required this.machineryId,
    required this.hireDate,
    required this.fromTime,
    required this.toTime,
    required this.totalHours,
    required this.amountPaid,
    required this.status,
    required this.notes,
    required this.approver,
    this.approverRemarks,
    this.updatedBy,
    this.createdAt,
    required this.modifiedAt,
    required this.machine,
  });

  factory ApprovelsMachineHireModel.fromJson(Map<String, dynamic> json) {
    return ApprovelsMachineHireModel(
      hireId: json['hireId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      machineryId: json['machineryId']?.toString() ?? '',
      hireDate: json['hireDate']?.toString() ?? '',
      fromTime: json['fromTime']?.toString() ?? '',
      toTime: json['toTime']?.toString() ?? '',
      totalHours: json['totalHours']?.toString() ?? '',
      amountPaid: json['amountPaid']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      approver: json['approver']?.toString() ?? '',
      approverRemarks: json['approverRemarks']?.toString(),
      updatedBy: json['updatedBy']?.toString(),
      createdAt: json['created_at'] != null
          ? CreatedAt.fromJson(json['created_at'] as Map<String, dynamic>)
          : null,
      modifiedAt: json['modified_at']?.toString() ?? '',
      machine: json['machine']?.toString() ?? '',
    );
  }

  MachineHireModel toMachineHireModel() {
    return MachineHireModel(
      hireId: hireId,
      userId: userId,
      projectId: projectId,
      machineryId: machineryId,
      hireDate: hireDate,
      fromTime: fromTime,
      toTime: toTime,
      totalHours: totalHours,
      amountPaid: amountPaid,
      status: status,
      notes: notes,
      approver: approver,
      approverRemarks: approverRemarks,
      updatedBy: updatedBy,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      machine: machine,
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
      'machine': machine,
    };
  }
}
