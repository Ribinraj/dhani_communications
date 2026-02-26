class ApprovelsLabourattendencemodel {
  final String attendanceId;
  final String userId;
  final String laborType;
  final String projectId;
  final String? contcatorName;
  final String totalLabours;
  final String? laborName;
  final String? laborMobile;
  final String hireDate;
  final String punchIn;
  final String? punchOut;
  final String? totalHours;
  final String? wages;
  final String attendanceLatt;
  final String attendanceLong;
  final String distanceFromHQ;
  final String picture;
  final String? punchOutPicture;
  final String? userRemarks;
  final String status;
  final String approver;
  final String? approverRemarks;
  final String? approvedBy;
  final String? headquarterRemarks;
  final String createdDate;
  final String lastModifiedDate;
  final String projectName;
  final String employeeName;

  ApprovelsLabourattendencemodel({
    required this.attendanceId,
    required this.userId,
    required this.laborType,
    required this.projectId,
    this.contcatorName,
    required this.totalLabours,
    this.laborName,
    this.laborMobile,
    required this.hireDate,
    required this.punchIn,
    this.punchOut,
    this.totalHours,
    this.wages,
    required this.attendanceLatt,
    required this.attendanceLong,
    required this.distanceFromHQ,
    required this.picture,
    this.punchOutPicture,
    this.userRemarks,
    required this.status,
    required this.approver,
    this.approverRemarks,
    this.approvedBy,
    this.headquarterRemarks,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.projectName,
    required this.employeeName,
  });

  factory ApprovelsLabourattendencemodel.fromJson(Map<String, dynamic> json) {
    return ApprovelsLabourattendencemodel(
      attendanceId: json['attendanceId'] ?? '',
      userId: json['userId'] ?? '',
      laborType: json['laborType'] ?? '',
      projectId: json['projectId'] ?? '',
      contcatorName: json['contcatorName'],
      totalLabours: json['totalLabours'] ?? '',
      laborName: json['laborName'],
      laborMobile: json['laborMobile'],
      hireDate: json['hireDate'] ?? '',
      punchIn: json['punchIn'] ?? '',
      punchOut: json['punchOut'],
      totalHours: json['totalHours'],
      wages: json['wages'],
      attendanceLatt: json['attendanceLatt'] ?? '',
      attendanceLong: json['attendanceLong'] ?? '',
      distanceFromHQ: json['distanceFromHQ'] ?? '',
      picture: json['picture'] ?? '',
      punchOutPicture: json['punchOutPicture'],
      userRemarks: json['userRemarks'],
      status: json['status'] ?? '',
      approver: json['approver'] ?? '',
      approverRemarks: json['approverRemarks'],
      approvedBy: json['approvedBy'],
      headquarterRemarks: json['headquarterRemarks'],
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      projectName: json['projectName'] ?? '',
      employeeName: json['employeeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "attendanceId": attendanceId,
      "userId": userId,
      "laborType": laborType,
      "projectId": projectId,
      "contcatorName": contcatorName,
      "totalLabours": totalLabours,
      "laborName": laborName,
      "laborMobile": laborMobile,
      "hireDate": hireDate,
      "punchIn": punchIn,
      "punchOut": punchOut,
      "totalHours": totalHours,
      "wages": wages,
      "attendanceLatt": attendanceLatt,
      "attendanceLong": attendanceLong,
      "distanceFromHQ": distanceFromHQ,
      "picture": picture,
      "punchOutPicture": punchOutPicture,
      "userRemarks": userRemarks,
      "status": status,
      "approver": approver,
      "approverRemarks": approverRemarks,
      "approvedBy": approvedBy,
      "headquarterRemarks": headquarterRemarks,
      "createdDate": createdDate,
      "lastModifiedDate": lastModifiedDate,
      "projectName": projectName,
      "employeeName": employeeName,
    };
  }
}