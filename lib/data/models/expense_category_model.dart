/// Model for Expense Category from masters/expensecategories API
class ExpenseCategoryModel {
  final String expenseCategoryId;
  final String expenseCategory;
  final String requireLabor;
  final String requireVehicle;
  final String requireFuel;
  final String createdDate;
  final String lastModifiedDate;

  ExpenseCategoryModel({
    required this.expenseCategoryId,
    required this.expenseCategory,
    required this.requireLabor,
    required this.requireVehicle,
    required this.requireFuel,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      expenseCategoryId: json['expenseCategoryId'] ?? '',
      expenseCategory: json['expenseCategory'] ?? '',
      requireLabor: json['requireLabor'] ?? 'NO',
      requireVehicle: json['requireVehicle'] ?? 'NO',
      requireFuel: json['requireFuel'] ?? 'NO',
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expenseCategoryId': expenseCategoryId,
      'expenseCategory': expenseCategory,
      'requireLabor': requireLabor,
      'requireVehicle': requireVehicle,
      'requireFuel': requireFuel,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
    };
  }
}
