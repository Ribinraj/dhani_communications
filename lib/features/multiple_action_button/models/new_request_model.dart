class NewRequestModel {
  final int requestCategoryId;
  final String notes;

  NewRequestModel({required this.requestCategoryId, required this.notes});

  Map<String, dynamic> toJson() {
    return {'requestCategoryId': requestCategoryId, 'notes': notes};
  }
}
