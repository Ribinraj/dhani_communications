class NewMachineryHireRequestModel {
  final int projectId;
  final int machineryId;
  final String hireDate;
  final String fromTime;
  final String toTime;
  final String amountPaid;
  final String notes;

  NewMachineryHireRequestModel({
    required this.projectId,
    required this.machineryId,
    required this.hireDate,
    required this.fromTime,
    required this.toTime,
    required this.amountPaid,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'machineryId': machineryId,
      'hireDate': hireDate,
      'fromTime': fromTime,
      'toTime': toTime,
      'amountPaid': amountPaid,
      'notes': notes,
    };
  }
}
