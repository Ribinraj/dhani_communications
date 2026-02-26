class ApproveDprDataModel {
  final String progressId;
  final String dprId;
  final String userId;
  final String progressDate;
  final String progressQuantity;
  final String createdDate;
  final String lastModifiedDate;
  final String status;
  final String approver;
  final String? approvedBy;
  final String? userRemarks;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final String employeeName;
  final String projectId;
  final String dprName;
  final String projectName;

  ApproveDprDataModel({
    required this.progressId,
    required this.dprId,
    required this.userId,
    required this.progressDate,
    required this.progressQuantity,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.status,
    required this.approver,
    this.approvedBy,
    this.userRemarks,
    this.approverRemarks,
    this.headquarterRemarks,
    required this.employeeName,
    required this.projectId,
    required this.dprName,
    required this.projectName,
  });

  factory ApproveDprDataModel.fromJson(Map<String, dynamic> json) {
    return ApproveDprDataModel(
      progressId: json['progressId'] ?? '',
      dprId: json['dprId'] ?? '',
      userId: json['userId'] ?? '',
      progressDate: json['progressDate'] ?? '',
      progressQuantity: json['progressQuantity'] ?? '',
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      status: json['status'] ?? '',
      approver: json['approver'] ?? '',
      approvedBy: json['approvedBy'],
      userRemarks: json['userRemarks'],
      approverRemarks: json['approverRemarks'],
      headquarterRemarks: json['headquarterRemarks'],
      employeeName: json['employeeName'] ?? '',
      projectId: json['projectId'] ?? '',
      dprName: json['dprName'] ?? '',
      projectName: json['projectName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressId": progressId,
      "dprId": dprId,
      "userId": userId,
      "progressDate": progressDate,
      "progressQuantity": progressQuantity,
      "createdDate": createdDate,
      "lastModifiedDate": lastModifiedDate,
      "status": status,
      "approver": approver,
      "approvedBy": approvedBy,
      "userRemarks": userRemarks,
      "approverRemarks": approverRemarks,
      "headquarterRemarks": headquarterRemarks,
      "employeeName": employeeName,
      "projectId": projectId,
      "dprName": dprName,
      "projectName": projectName,
    };
  }
}