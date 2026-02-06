/// Model for labor attendance record
class LaborAttendanceModel {
  final int attendanceId;
  final int userId;
  final String laborType;
  final int projectId;
  final String contractorName;
  final int totalLabours;
  final String laborName;
  final String laborMobile;
  final String hireDate;
  final String punchIn;
  final String punchOut;
  final String totalHours;
  final double wages;
  final double attendanceLatt;
  final double attendanceLong;
  final double distanceFromHQ;
  final String picture;
  final String punchOutPicture;
  final String userRemarks;
  final String status;
  final String approver;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final int? approvedBy;
  final String createdDate;
  final String lastModifiedDate;

  LaborAttendanceModel({
    required this.attendanceId,
    required this.userId,
    required this.laborType,
    required this.projectId,
    required this.contractorName,
    required this.totalLabours,
    required this.laborName,
    required this.laborMobile,
    required this.hireDate,
    required this.punchIn,
    required this.punchOut,
    required this.totalHours,
    required this.wages,
    required this.attendanceLatt,
    required this.attendanceLong,
    required this.distanceFromHQ,
    required this.picture,
    required this.punchOutPicture,
    required this.userRemarks,
    required this.status,
    required this.approver,
    this.approverRemarks,
    this.headquarterRemarks,
    this.approvedBy,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory LaborAttendanceModel.fromJson(Map<String, dynamic> json) {
    return LaborAttendanceModel(
      attendanceId: _parseInt(json['attendanceId']),
      userId: _parseInt(json['userId']),
      laborType: json['laborType'] ?? '',
      projectId: _parseInt(json['projectId']),
      contractorName: json['contcatorName'] ?? json['contractorName'] ?? '',
      totalLabours: _parseInt(json['totalLabours']),
      laborName: json['laborName'] ?? '',
      laborMobile: json['laborMobile'] ?? '',
      hireDate: json['hireDate'] ?? '',
      punchIn: json['punchIn'] ?? '',
      punchOut: json['punchOut'] ?? '',
      totalHours: json['totalHours'] ?? '',
      wages: _parseDouble(json['wages']),
      attendanceLatt: _parseDouble(json['attendanceLatt']),
      attendanceLong: _parseDouble(json['attendanceLong']),
      distanceFromHQ: _parseDouble(json['distanceFromHQ']),
      picture: json['picture'] ?? '',
      punchOutPicture: json['punchOutPicture'] ?? '',
      userRemarks: json['userRemarks'] ?? '',
      status: json['status'] ?? '',
      approver: json['approver'] ?? '',
      approverRemarks: json['approverRemarks'],
      headquarterRemarks: json['headquarterRemarks'],
      approvedBy: json['approvedBy'] != null
          ? _parseInt(json['approvedBy'])
          : null,
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
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
      'attendanceId': attendanceId,
      'userId': userId,
      'laborType': laborType,
      'projectId': projectId,
      'contractorName': contractorName,
      'totalLabours': totalLabours,
      'laborName': laborName,
      'laborMobile': laborMobile,
      'hireDate': hireDate,
      'punchIn': punchIn,
      'punchOut': punchOut,
      'totalHours': totalHours,
      'wages': wages,
      'attendanceLatt': attendanceLatt,
      'attendanceLong': attendanceLong,
      'distanceFromHQ': distanceFromHQ,
      'picture': picture,
      'punchOutPicture': punchOutPicture,
      'userRemarks': userRemarks,
      'status': status,
      'approver': approver,
      'approverRemarks': approverRemarks,
      'headquarterRemarks': headquarterRemarks,
      'approvedBy': approvedBy,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
    };
  }
}
