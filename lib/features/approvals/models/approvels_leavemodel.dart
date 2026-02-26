class ApproveLeaveModel {
  final String leaveId;
  final String userId;
  final String projectId;
  final String leavesLatt;
  final String leavesLong;
  final String distanceFromHQ;
  final String leaveCategoryId;
  final String fromDate;
  final String toDate;
  final String total;
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
  final String leaveCategoryName;
  final List<LeaveDocumentModel> leaveDocuments;

  ApproveLeaveModel({
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
    this.userRemarks,
    this.approverRemarks,
    this.headquarterRemarks,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.projectName,
    required this.employeeName,
    required this.leaveCategoryName,
    required this.leaveDocuments,
  });

  factory ApproveLeaveModel.fromJson(Map<String, dynamic> json) {
    return ApproveLeaveModel(
      leaveId: json['leaveId'] ?? '',
      userId: json['userId'] ?? '',
      projectId: json['projectId'] ?? '',
      leavesLatt: json['leavesLatt'] ?? '',
      leavesLong: json['leavesLong'] ?? '',
      distanceFromHQ: json['distanceFromHQ'] ?? '',
      leaveCategoryId: json['leaveCategoryId'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      total: json['total'] ?? '',
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
      leaveCategoryName: json['leaveCategoryName'] ?? '',
      leaveDocuments: json['leaveDocuments'] != null
          ? List<LeaveDocumentModel>.from(
              json['leaveDocuments']
                  .map((x) => LeaveDocumentModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "leaveId": leaveId,
      "userId": userId,
      "projectId": projectId,
      "leavesLatt": leavesLatt,
      "leavesLong": leavesLong,
      "distanceFromHQ": distanceFromHQ,
      "leaveCategoryId": leaveCategoryId,
      "fromDate": fromDate,
      "toDate": toDate,
      "total": total,
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
      "leaveCategoryName": leaveCategoryName,
      "leaveDocuments":
          leaveDocuments.map((x) => x.toJson()).toList(),
    };
  }
}
class LeaveDocumentModel {
  final String leaveDocumentId;
  final String leaveId;
  final String document;
  final String fileName;
  final String createdDate;
  final String lastModifiedDate;

  LeaveDocumentModel({
    required this.leaveDocumentId,
    required this.leaveId,
    required this.document,
    required this.fileName,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory LeaveDocumentModel.fromJson(Map<String, dynamic> json) {
    return LeaveDocumentModel(
      leaveDocumentId: json['leaveDocumentId'] ?? '',
      leaveId: json['leaveId'] ?? '',
      document: json['document'] ?? '',
      fileName: json['fileName'] ?? '',
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "leaveDocumentId": leaveDocumentId,
      "leaveId": leaveId,
      "document": document,
      "fileName": fileName,
      "createdDate": createdDate,
      "lastModifiedDate": lastModifiedDate,
    };
  }
}