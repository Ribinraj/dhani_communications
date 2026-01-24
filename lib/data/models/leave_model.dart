/// Model for leave record from list API
class LeaveModel {
  final int leaveId;
  final String leaveFromDate;
  final String leaveToDate;
  final int leaveCategoryId;
  final String leaveCategoryName;
  final String status;
  final String userRemarks;

  LeaveModel({
    required this.leaveId,
    required this.leaveFromDate,
    required this.leaveToDate,
    required this.leaveCategoryId,
    required this.leaveCategoryName,
    required this.status,
    required this.userRemarks,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      leaveId: json['leaveId'] ?? 0,
      leaveFromDate: json['leaveFromDate'] ?? '',
      leaveToDate: json['leaveToDate'] ?? '',
      leaveCategoryId: json['leaveCategoryId'] ?? 0,
      leaveCategoryName: json['leaveCategoryName'] ?? '',
      status: json['status'] ?? '',
      userRemarks: json['userRemarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveId': leaveId,
      'leaveFromDate': leaveFromDate,
      'leaveToDate': leaveToDate,
      'leaveCategoryId': leaveCategoryId,
      'leaveCategoryName': leaveCategoryName,
      'status': status,
      'userRemarks': userRemarks,
    };
  }
}
