/// Model for leave document
class LeaveDocument {
  final String documentUrl;

  LeaveDocument({required this.documentUrl});

  factory LeaveDocument.fromJson(Map<String, dynamic> json) {
    return LeaveDocument(
      documentUrl: json['documentUrl'] ?? json['document'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'documentUrl': documentUrl};
  }
}

/// Model for leave record from list API
class LeaveModel {
  final int leaveId;
  final int userId;
  final int projectId;
  final double leavesLatt;
  final double leavesLong;
  final double distanceFromHQ;
  final int leaveCategoryId;
  final String fromDate;
  final String toDate;
  final int total;
  final String approver;
  final String status;
  final int? approvedBy;
  final String userRemarks;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final String createdDate;
  final String lastModifiedDate;
  final String leaveCategoryName;
  final List<LeaveDocument> leaveDocuments;

  LeaveModel({
    required this.leaveId,
    required this.userId,
    required this.projectId,
    required this.leavesLatt,
    required this.leavesLong,
    required this.distanceFromHQ,
    required this.leaveCategoryId,
    required this.fromDate,
    required this.toDate,
    required this.total,
    required this.approver,
    required this.status,
    this.approvedBy,
    required this.userRemarks,
    this.approverRemarks,
    this.headquarterRemarks,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.leaveCategoryName,
    required this.leaveDocuments,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      leaveId: _parseInt(json['leaveId']),
      userId: _parseInt(json['userId']),
      projectId: _parseInt(json['projectId']),
      leavesLatt: _parseDouble(json['leavesLatt']),
      leavesLong: _parseDouble(json['leavesLong']),
      distanceFromHQ: _parseDouble(json['distanceFromHQ']),
      leaveCategoryId: _parseInt(json['leaveCategoryId']),
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      total: _parseInt(json['total']),
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
      leaveCategoryName: json['leaveCategoryName'] ?? '',
      leaveDocuments:
          (json['leaveDocuments'] as List<dynamic>?)
              ?.map((e) => LeaveDocument.fromJson(e as Map<String, dynamic>))
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
      'leaveId': leaveId,
      'userId': userId,
      'projectId': projectId,
      'leavesLatt': leavesLatt,
      'leavesLong': leavesLong,
      'distanceFromHQ': distanceFromHQ,
      'leaveCategoryId': leaveCategoryId,
      'fromDate': fromDate,
      'toDate': toDate,
      'total': total,
      'approver': approver,
      'status': status,
      'approvedBy': approvedBy,
      'userRemarks': userRemarks,
      'approverRemarks': approverRemarks,
      'headquarterRemarks': headquarterRemarks,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'leaveCategoryName': leaveCategoryName,
      'leaveDocuments': leaveDocuments.map((e) => e.toJson()).toList(),
    };
  }
}
