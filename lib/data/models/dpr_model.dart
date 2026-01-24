/// Model for DPR record from list API
class DprModel {
  final int dprId;
  final String dprDate;
  final int projectId;
  final String projectName;
  final String status;
  final int progress;

  DprModel({
    required this.dprId,
    required this.dprDate,
    required this.projectId,
    required this.projectName,
    required this.status,
    required this.progress,
  });

  factory DprModel.fromJson(Map<String, dynamic> json) {
    return DprModel(
      dprId: json['dprId'] ?? 0,
      dprDate: json['dprDate'] ?? '',
      projectId: json['projectId'] ?? 0,
      projectName: json['projectName'] ?? '',
      status: json['status'] ?? '',
      progress: json['progress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dprId': dprId,
      'dprDate': dprDate,
      'projectId': projectId,
      'projectName': projectName,
      'status': status,
      'progress': progress,
    };
  }
}

/// Model for DPR details API response
class DprDetailsModel {
  final int dprId;
  final String dprDate;
  final int projectId;
  final int progress;
  final String userRemarks;
  final String status;

  DprDetailsModel({
    required this.dprId,
    required this.dprDate,
    required this.projectId,
    required this.progress,
    required this.userRemarks,
    required this.status,
  });

  factory DprDetailsModel.fromJson(Map<String, dynamic> json) {
    return DprDetailsModel(
      dprId: json['dprId'] ?? 0,
      dprDate: json['dprDate'] ?? '',
      projectId: json['projectId'] ?? 0,
      progress: json['progress'] ?? 0,
      userRemarks: json['userRemarks'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dprId': dprId,
      'dprDate': dprDate,
      'projectId': projectId,
      'progress': progress,
      'userRemarks': userRemarks,
      'status': status,
    };
  }
}

/// Model for DPR submission from my submissions API
class DprSubmissionModel {
  final int dprId;
  final String dprDate;
  final int projectId;
  final int progress;
  final String status;

  DprSubmissionModel({
    required this.dprId,
    required this.dprDate,
    required this.projectId,
    required this.progress,
    required this.status,
  });

  factory DprSubmissionModel.fromJson(Map<String, dynamic> json) {
    return DprSubmissionModel(
      dprId: json['dprId'] ?? 0,
      dprDate: json['dprDate'] ?? '',
      projectId: json['projectId'] ?? 0,
      progress: json['progress'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dprId': dprId,
      'dprDate': dprDate,
      'projectId': projectId,
      'progress': progress,
      'status': status,
    };
  }
}
