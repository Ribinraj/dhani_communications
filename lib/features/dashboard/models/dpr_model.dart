/// Model for DPR record from list API
class DprModel {
  final int dprId;
  final int projectId;
  final String sic;
  final String description;
  final String uom;
  final String scq;
  final int createdBy;
  final String createdDate;
  final String lastModifiedDate;
  final String completed;
  final int percentageCompleted;

  DprModel({
    required this.dprId,
    required this.projectId,
    required this.sic,
    required this.description,
    required this.uom,
    required this.scq,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.completed,
    required this.percentageCompleted,
  });

  factory DprModel.fromJson(Map<String, dynamic> json) {
    return DprModel(
      dprId: _parseInt(json['dprId']),
      projectId: _parseInt(json['projectId']),
      sic: json['sic'] ?? '',
      description: json['description'] ?? '',
      uom: json['uom'] ?? '',
      scq: json['scq']?.toString() ?? '0',
      createdBy: _parseInt(json['createdBy']),
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      completed: json['completed']?.toString() ?? '0',
      percentageCompleted: _parseInt(json['percentageCompleted']),
    );
  }

  /// Parse int from dynamic value (handles both int and String)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'dprId': dprId,
      'projectId': projectId,
      'sic': sic,
      'description': description,
      'uom': uom,
      'scq': scq,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'completed': completed,
      'percentageCompleted': percentageCompleted,
    };
  }
}

/// Model for DPR details API response
class DprDetailsModel {
  final int dprId;
  final int projectId;
  final String sic;
  final String description;
  final String uom;
  final String scq;
  final int createdBy;
  final String createdDate;
  final String lastModifiedDate;
  final double completed;
  final int percentageCompleted;
  final List<DprTransactionModel> transactions;

  DprDetailsModel({
    required this.dprId,
    required this.projectId,
    required this.sic,
    required this.description,
    required this.uom,
    required this.scq,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.completed,
    required this.percentageCompleted,
    required this.transactions,
  });

  factory DprDetailsModel.fromJson(Map<String, dynamic> json) {
    return DprDetailsModel(
      dprId: _parseInt(json['dprId']),
      projectId: _parseInt(json['projectId']),
      sic: json['sic']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      uom: json['uom']?.toString() ?? '',
      scq: json['scq']?.toString() ?? '0',
      createdBy: _parseInt(json['createdBy']),
      createdDate: json['createdDate']?.toString() ?? '',
      lastModifiedDate: json['lastModifiedDate']?.toString() ?? '',
      completed: _parseDouble(json['completed']),
      percentageCompleted: _parseInt(json['percentageCompleted']),
      transactions:
          (json['transactions'] as List<dynamic>?)
              ?.map(
                (e) => DprTransactionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  /// Parse int from dynamic value (handles both int and String)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  /// Parse double from dynamic value
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'dprId': dprId,
      'projectId': projectId,
      'sic': sic,
      'description': description,
      'uom': uom,
      'scq': scq,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'completed': completed,
      'percentageCompleted': percentageCompleted,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }
}

/// Model for DPR transaction (progress entry)
class DprTransactionModel {
  final int progressId;
  final int dprId;
  final int userId;
  final String progressDate;
  final double progressQuantity;
  final String createdDate;
  final String lastModifiedDate;
  final String status;
  final int approver;
  final int approvedBy;
  final String? userRemarks;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final String userName;

  DprTransactionModel({
    required this.progressId,
    required this.dprId,
    required this.userId,
    required this.progressDate,
    required this.progressQuantity,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.status,
    required this.approver,
    required this.approvedBy,
    this.userRemarks,
    this.approverRemarks,
    this.headquarterRemarks,
    required this.userName,
  });

  factory DprTransactionModel.fromJson(Map<String, dynamic> json) {
    return DprTransactionModel(
      progressId: _parseInt(json['progressId']),
      dprId: _parseInt(json['dprId']),
      userId: _parseInt(json['userId']),
      progressDate: json['progressDate']?.toString() ?? '',
      progressQuantity: _parseDouble(json['progressQuantity']),
      createdDate: json['createdDate']?.toString() ?? '',
      lastModifiedDate: json['lastModifiedDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      approver: _parseInt(json['approver']),
      approvedBy: _parseInt(json['approvedBy']),
      userRemarks: json['userRemarks']?.toString(),
      approverRemarks: json['approverRemarks']?.toString(),
      headquarterRemarks: json['headquarterRemarks']?.toString(),
      userName: json['userName']?.toString() ?? '-',
    );
  }

  /// Parse int from dynamic value (handles both int and String)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  /// Parse double from dynamic value
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'progressId': progressId,
      'dprId': dprId,
      'userId': userId,
      'progressDate': progressDate,
      'progressQuantity': progressQuantity,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'status': status,
      'approver': approver,
      'approvedBy': approvedBy,
      'userRemarks': userRemarks,
      'approverRemarks': approverRemarks,
      'headquarterRemarks': headquarterRemarks,
      'userName': userName,
    };
  }

  /// Get color based on status
  String get statusDisplayText {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return 'Approved';
      case 'PENDING':
        return 'Pending';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }
}

/// Model for DPR submission from my submissions API
class DprSubmissionModel {
  final int progressId;
  final int dprId;
  final int userId;
  final String progressDate;
  final double progressQuantity;
  final String createdDate;
  final String lastModifiedDate;
  final String status;
  final int approver;
  final int approvedBy;
  final String? userRemarks;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final int projectId;
  final String uom;
  final String dprName;
  final String projectName;

  DprSubmissionModel({
    required this.progressId,
    required this.dprId,
    required this.userId,
    required this.progressDate,
    required this.progressQuantity,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.status,
    required this.approver,
    required this.approvedBy,
    this.userRemarks,
    this.approverRemarks,
    this.headquarterRemarks,
    required this.projectId,
    required this.uom,
    required this.dprName,
    required this.projectName,
  });

  factory DprSubmissionModel.fromJson(Map<String, dynamic> json) {
    return DprSubmissionModel(
      progressId: _parseInt(json['progressId']),
      dprId: _parseInt(json['dprId']),
      userId: _parseInt(json['userId']),
      progressDate: json['progressDate']?.toString() ?? '',
      progressQuantity: _parseDouble(json['progressQuantity']),
      createdDate: json['createdDate']?.toString() ?? '',
      lastModifiedDate: json['lastModifiedDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      approver: _parseInt(json['approver']),
      approvedBy: _parseInt(json['approvedBy']),
      userRemarks: json['userRemarks']?.toString(),
      approverRemarks: json['approverRemarks']?.toString(),
      headquarterRemarks: json['headquarterRemarks']?.toString(),
      projectId: _parseInt(json['projectId']),
      uom: json['uom']?.toString() ?? '',
      dprName: json['dprName']?.toString() ?? '',
      projectName: json['projectName']?.toString() ?? '-',
    );
  }

  /// Parse int from dynamic value (handles both int and String)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  /// Parse double from dynamic value
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'progressId': progressId,
      'dprId': dprId,
      'userId': userId,
      'progressDate': progressDate,
      'progressQuantity': progressQuantity,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'status': status,
      'approver': approver,
      'approvedBy': approvedBy,
      'userRemarks': userRemarks,
      'approverRemarks': approverRemarks,
      'headquarterRemarks': headquarterRemarks,
      'projectId': projectId,
      'uom': uom,
      'dprName': dprName,
      'projectName': projectName,
    };
  }

  /// Get display text for status
  String get statusDisplayText {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return 'Approved';
      case 'PENDING':
        return 'Pending';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }
}
