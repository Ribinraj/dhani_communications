/// Model for company asset from list API
class CompanyAssetModel {
  final int assetId;
  final int userId;
  final int assetGroup;
  final String assetName;
  final String make;
  final String model;
  final String yearOfPurchase;
  final int qty;
  final int unit;
  final String transactionDate;
  final String documentNo;
  final String picture;
  final double approxCost;
  final String headquarter;
  final String status;
  final String? transferTo;
  final String createdDate;
  final String lastModifiedDate;
  final String assetGroupName;

  CompanyAssetModel({
    required this.assetId,
    required this.userId,
    required this.assetGroup,
    required this.assetName,
    required this.make,
    required this.model,
    required this.yearOfPurchase,
    required this.qty,
    required this.unit,
    required this.transactionDate,
    required this.documentNo,
    required this.picture,
    required this.approxCost,
    required this.headquarter,
    required this.status,
    this.transferTo,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.assetGroupName,
  });

  factory CompanyAssetModel.fromJson(Map<String, dynamic> json) {
    return CompanyAssetModel(
      assetId: _parseInt(json['assetId']),
      userId: _parseInt(json['userId']),
      assetGroup: _parseInt(json['assetGroup']),
      assetName: json['assetName'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      yearOfPurchase: json['yearOfPurchase'] ?? '',
      qty: _parseInt(json['qty']),
      unit: _parseInt(json['unit']),
      transactionDate: json['transactionDate'] ?? '',
      documentNo: json['documentNo'] ?? '',
      picture: json['picture'] ?? '',
      approxCost: _parseDouble(json['approxCost']),
      headquarter: json['headquarter'] ?? '',
      status: json['status'] ?? '',
      transferTo: json['transferTo'],
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      assetGroupName: json['assetGroupName'] ?? '',
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
      'assetId': assetId,
      'userId': userId,
      'assetGroup': assetGroup,
      'assetName': assetName,
      'make': make,
      'model': model,
      'yearOfPurchase': yearOfPurchase,
      'qty': qty,
      'unit': unit,
      'transactionDate': transactionDate,
      'documentNo': documentNo,
      'picture': picture,
      'approxCost': approxCost,
      'headquarter': headquarter,
      'status': status,
      'transferTo': transferTo,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'assetGroupName': assetGroupName,
    };
  }
}
