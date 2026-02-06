/// Model for expense document
class ExpenseDocument {
  final String documentUrl;

  ExpenseDocument({required this.documentUrl});

  factory ExpenseDocument.fromJson(Map<String, dynamic> json) {
    return ExpenseDocument(
      documentUrl: json['documentUrl'] ?? json['document'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'documentUrl': documentUrl};
  }
}

/// Model for expense attachment (for creating expenses)
class ExpenseAttachment {
  final String fileName;
  final String file;

  ExpenseAttachment({required this.fileName, required this.file});

  Map<String, dynamic> toJson() {
    return {'fileName': fileName, 'file': file};
  }
}

/// Model for expense record from list API
class ExpenseModel {
  final int expenseId;
  final int userId;
  final int projectId;
  final String expenseDate;
  final int expenseCategoryId;
  final double expenseAmount;
  final int? vehicleId;
  final double? fuelFillKm;
  final double? lastServiceKm;
  final String approver;
  final String status;
  final int? approvedBy;
  final String userRemarks;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final String createdDate;
  final String lastModifiedDate;
  final String expenseCategoryName;
  final List<ExpenseDocument> expenseDocuments;

  ExpenseModel({
    required this.expenseId,
    required this.userId,
    required this.projectId,
    required this.expenseDate,
    required this.expenseCategoryId,
    required this.expenseAmount,
    this.vehicleId,
    this.fuelFillKm,
    this.lastServiceKm,
    required this.approver,
    required this.status,
    this.approvedBy,
    required this.userRemarks,
    this.approverRemarks,
    this.headquarterRemarks,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.expenseCategoryName,
    required this.expenseDocuments,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: _parseInt(json['expenseId']),
      userId: _parseInt(json['userId']),
      projectId: _parseInt(json['projectId']),
      expenseDate: json['expenseDate'] ?? '',
      expenseCategoryId: _parseInt(json['expenseCategoryId']),
      expenseAmount: _parseDouble(json['expenseAmount']),
      vehicleId: json['vehicleId'] != null
          ? _parseInt(json['vehicleId'])
          : null,
      fuelFillKm: json['fuelFillKm'] != null
          ? _parseDouble(json['fuelFillKm'])
          : null,
      lastServiceKm: json['lastServiceKm'] != null
          ? _parseDouble(json['lastServiceKm'])
          : null,
      approver: json['approver'] ?? '',
      status: json['status'] ?? '',
      approvedBy: json['approvedBy'] != null
          ? _parseInt(json['approvedBy'])
          : null,
      userRemarks: json['userRemarks'] ?? '',
      approverRemarks: json['approverRemarks'],
      headquarterRemarks: json['headquarterRemarks'],
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      expenseCategoryName: json['expenseCategoryName'] ?? '',
      expenseDocuments:
          (json['expenseDocuments'] as List<dynamic>?)
              ?.map((e) => ExpenseDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Parse int from dynamic value (handles both int and String)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Parse double from dynamic value (handles both num and String)
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'expenseId': expenseId,
      'userId': userId,
      'projectId': projectId,
      'expenseDate': expenseDate,
      'expenseCategoryId': expenseCategoryId,
      'expenseAmount': expenseAmount,
      'vehicleId': vehicleId,
      'fuelFillKm': fuelFillKm,
      'lastServiceKm': lastServiceKm,
      'approver': approver,
      'status': status,
      'approvedBy': approvedBy,
      'userRemarks': userRemarks,
      'approverRemarks': approverRemarks,
      'headquarterRemarks': headquarterRemarks,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'expenseCategoryName': expenseCategoryName,
      'expenseDocuments': expenseDocuments.map((e) => e.toJson()).toList(),
    };
  }
}
