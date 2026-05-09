/// Model for a single request item from the request list API
class RequestModel {
  final String requestId;
  final String requestCategoryId;
  final String requestedBy;
  final String notes;
  final String status;
  final String updatedBy;
  final String createdAt;
  final String modifiedAt;
  final String requestCategory;

  RequestModel({
    required this.requestId,
    required this.requestCategoryId,
    required this.requestedBy,
    required this.notes,
    required this.status,
    required this.updatedBy,
    required this.createdAt,
    required this.modifiedAt,
    required this.requestCategory,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    // Handle created_at which can be an object or a string
    String createdAtStr = '';
    final createdAtRaw = json['created_at'];
    if (createdAtRaw is Map<String, dynamic>) {
      createdAtStr = createdAtRaw['date'] ?? '';
    } else if (createdAtRaw is String) {
      createdAtStr = createdAtRaw;
    }

    return RequestModel(
      requestId: json['requestId']?.toString() ?? '',
      requestCategoryId: json['requestCategoryId']?.toString() ?? '',
      requestedBy: json['requestedBy']?.toString() ?? '-',
      notes: json['notes']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      updatedBy: json['updatedBy']?.toString() ?? '-',
      createdAt: createdAtStr,
      modifiedAt: json['modified_at']?.toString() ?? '',
      requestCategory: json['requestCategory']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'requestCategoryId': requestCategoryId,
      'requestedBy': requestedBy,
      'notes': notes,
      'status': status,
      'updatedBy': updatedBy,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'requestCategory': requestCategory,
    };
  }
}
