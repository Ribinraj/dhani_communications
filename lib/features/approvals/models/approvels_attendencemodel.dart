class ApprovelsAttendencemodel {
  final String attendanceId;
  final String userId;
  final String projectId;
  final String date;
  final String attendanceType;
  final String attendance;
  final String attendanceLatt;
  final String attendanceLong;
  final String distanceFromHQ;
  final String picture;
  final String status;
  final String approver;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final String? approvedBy;
  final String userRemarks;
  final String createdDate;
  final String lastModifiedDate;
  final String employeeName;
  final String projectName;

  ApprovelsAttendencemodel({
    required this.attendanceId,
    required this.userId,
    required this.projectId,
    required this.date,
    required this.attendanceType,
    required this.attendance,
    required this.attendanceLatt,
    required this.attendanceLong,
    required this.distanceFromHQ,
    required this.picture,
    required this.status,
    required this.approver,
    this.approverRemarks,
    this.headquarterRemarks,
    this.approvedBy,
    required this.userRemarks,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.employeeName,
    required this.projectName,
  });

  factory ApprovelsAttendencemodel.fromJson(Map<String, dynamic> json) {
    return ApprovelsAttendencemodel(
      attendanceId: json['attendanceId'] ?? '',
      userId: json['userId'] ?? '',
      projectId: json['projectId'] ?? '',
      date: json['date'] ?? '',
      attendanceType: json['attendanceType'] ?? '',
      attendance: json['attendance'] ?? '',
      attendanceLatt: json['attendanceLatt'] ?? '',
      attendanceLong: json['attendanceLong'] ?? '',
      distanceFromHQ: json['distanceFromHQ'] ?? '',
      picture: json['picture'] ?? '',
      status: json['status'] ?? '',
      approver: json['approver'] ?? '',
      approverRemarks: json['approverRemarks'],
      headquarterRemarks: json['headquarterRemarks'],
      approvedBy: json['approvedBy'],
      userRemarks: json['userRemarks'] ?? '',
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      employeeName: json['employeeName'] ?? '',
      projectName: json['projectName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "attendanceId": attendanceId,
      "userId": userId,
      "projectId": projectId,
      "date": date,
      "attendanceType": attendanceType,
      "attendance": attendance,
      "attendanceLatt": attendanceLatt,
      "attendanceLong": attendanceLong,
      "distanceFromHQ": distanceFromHQ,
      "picture": picture,
      "status": status,
      "approver": approver,
      "approverRemarks": approverRemarks,
      "headquarterRemarks": headquarterRemarks,
      "approvedBy": approvedBy,
      "userRemarks": userRemarks,
      "createdDate": createdDate,
      "lastModifiedDate": lastModifiedDate,
      "employeeName": employeeName,
      "projectName": projectName,
    };
  }
}
