class ApprovelsExpensemodel {
  final String expenseId;
  final String userId;
  final String projectId;
  final String expenseDate;
  final String expenseCategoryId;
  final String expenseAmount;
  final String? vehicleId;
  final String? fuelFillKm;
  final String? lastServiceKm;
  final String approver;
  final String status;
  final String? approvedBy;
  final String? userRemarks;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final String createdDate;
  final String lastModifiedDate;
  final String projectName;
  final String employeeName;
  final String expenseCategoryName;
  final List<ExpenseDocumentModel> expenseDocuments;

  ApprovelsExpensemodel({
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
    this.userRemarks,
    this.approverRemarks,
    this.headquarterRemarks,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.projectName,
    required this.employeeName,
    required this.expenseCategoryName,
    required this.expenseDocuments,
  });

  factory ApprovelsExpensemodel.fromJson(Map<String, dynamic> json) {
    return ApprovelsExpensemodel(
      expenseId: json['expenseId'] ?? '',
      userId: json['userId'] ?? '',
      projectId: json['projectId'] ?? '',
      expenseDate: json['expenseDate'] ?? '',
      expenseCategoryId: json['expenseCategoryId'] ?? '',
      expenseAmount: json['expenseAmount'] ?? '',
      vehicleId: json['vehicleId'],
      fuelFillKm: json['fuelFillKm'],
      lastServiceKm: json['lastServiceKm'],
      approver: json['approver'] ?? '',
      status: json['status'] ?? '',
      approvedBy: json['approvedBy'],
      userRemarks: json['userRemarks'],
      approverRemarks: json['approverRemarks'],
      headquarterRemarks: json['headquarterRemarks'],
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      projectName: json['projectName'] ?? '',
      employeeName: json['employeeName'] ?? '',
      expenseCategoryName: json['expenseCategoryName'] ?? '',
      expenseDocuments: json['expenseDocuments'] != null
          ? List<ExpenseDocumentModel>.from(
              json['expenseDocuments']
                  .map((x) => ExpenseDocumentModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "expenseId": expenseId,
      "userId": userId,
      "projectId": projectId,
      "expenseDate": expenseDate,
      "expenseCategoryId": expenseCategoryId,
      "expenseAmount": expenseAmount,
      "vehicleId": vehicleId,
      "fuelFillKm": fuelFillKm,
      "lastServiceKm": lastServiceKm,
      "approver": approver,
      "status": status,
      "approvedBy": approvedBy,
      "userRemarks": userRemarks,
      "approverRemarks": approverRemarks,
      "headquarterRemarks": headquarterRemarks,
      "createdDate": createdDate,
      "lastModifiedDate": lastModifiedDate,
      "projectName": projectName,
      "employeeName": employeeName,
      "expenseCategoryName": expenseCategoryName,
      "expenseDocuments":
          expenseDocuments.map((x) => x.toJson()).toList(),
    };
  }
}
class ExpenseDocumentModel {
  final String expenseDocumentId;
  final String expenseId;
  final String document;
  final String fileName;
  final String createdDate;
  final String lastModifiedDate;

  ExpenseDocumentModel({
    required this.expenseDocumentId,
    required this.expenseId,
    required this.document,
    required this.fileName,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory ExpenseDocumentModel.fromJson(Map<String, dynamic> json) {
    return ExpenseDocumentModel(
      expenseDocumentId: json['expenseDocumentId'] ?? '',
      expenseId: json['expenseId'] ?? '',
      document: json['document'] ?? '',
      fileName: json['fileName'] ?? '',
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "expenseDocumentId": expenseDocumentId,
      "expenseId": expenseId,
      "document": document,
      "fileName": fileName,
      "createdDate": createdDate,
      "lastModifiedDate": lastModifiedDate,
    };
  }
}