class RequestCategoryModel {
  final String requestCategoryId;
  final String categoryName;
  final String modifiedAt;

  RequestCategoryModel({
    required this.requestCategoryId,
    required this.categoryName,
    required this.modifiedAt,
  });

  factory RequestCategoryModel.fromJson(Map<String, dynamic> json) {
    return RequestCategoryModel(
      requestCategoryId: json['requestCategoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      modifiedAt: json['modified_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestCategoryId': requestCategoryId,
      'categoryName': categoryName,
      'modified_at': modifiedAt,
    };
  }
}
