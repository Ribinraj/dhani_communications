/// Model for creating a new expense request
class NewExpenseRequestModel {
  final int projectId;
  final String expenseDate;
  final int expenseCategoryId;
  final double expenseAmount;
  final int? vehicleId;
  final int? fuelFillKm;
  final String? userRemarks;
  final List<NewExpenseAttachment>? attachements;

  NewExpenseRequestModel({
    required this.projectId,
    required this.expenseDate,
    required this.expenseCategoryId,
    required this.expenseAmount,
    this.vehicleId,
    this.fuelFillKm,
    this.userRemarks,
    this.attachements,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'projectId': projectId,
      'expenseDate': expenseDate,
      'expenseCategoryId': expenseCategoryId,
      'expenseAmount': expenseAmount,
    };

    if (vehicleId != null) json['vehicleId'] = vehicleId;
    if (fuelFillKm != null) json['fuelFillKm'] = fuelFillKm;
    if (userRemarks != null && userRemarks!.isNotEmpty) {
      json['userRemarks'] = userRemarks;
    }
    if (attachements != null && attachements!.isNotEmpty) {
      json['attachements'] = attachements!.map((a) => a.toJson()).toList();
    }

    return json;
  }
}

/// Attachment model for expense submission
class NewExpenseAttachment {
  final String fileName;
  final String file;

  NewExpenseAttachment({required this.fileName, required this.file});

  Map<String, dynamic> toJson() {
    return {'fileName': fileName, 'file': file};
  }
}
