/// Model for expense attachment
class ExpenseAttachment {
  final String fileName;
  final String file;

  ExpenseAttachment({
    required this.fileName,
    required this.file,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'file': file,
    };
  }
}

/// Model for expense record from list API
class ExpenseModel {
  final int expenseId;
  final String expenseDate;
  final int expenseCategoryId;
  final String expenseCategoryName;
  final double expenseAmount;
  final String status;
  final int vehicleId;
  final String vehicleNumber;

  ExpenseModel({
    required this.expenseId,
    required this.expenseDate,
    required this.expenseCategoryId,
    required this.expenseCategoryName,
    required this.expenseAmount,
    required this.status,
    required this.vehicleId,
    required this.vehicleNumber,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: json['expenseId'] ?? 0,
      expenseDate: json['expenseDate'] ?? '',
      expenseCategoryId: json['expenseCategoryId'] ?? 0,
      expenseCategoryName: json['expenseCategoryName'] ?? '',
      expenseAmount: (json['expenseAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      vehicleId: json['vehicleId'] ?? 0,
      vehicleNumber: json['vehicleNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expenseId': expenseId,
      'expenseDate': expenseDate,
      'expenseCategoryId': expenseCategoryId,
      'expenseCategoryName': expenseCategoryName,
      'expenseAmount': expenseAmount,
      'status': status,
      'vehicleId': vehicleId,
      'vehicleNumber': vehicleNumber,
    };
  }
}
