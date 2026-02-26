/// Model for attendance record
class AttendanceModel {
  final int attendanceId;
  final int userId;
  final int projectId;
  final String date;
  final String attendanceDate;
  final String attendanceType;
  final double attendance;
  final double attendanceLatt;
  final double attendanceLong;
  final double distanceFromHQ;
  final String picture;
  final String status;
  final String approver;
  final String? approverRemarks;
  final String? headquarterRemarks;
  final int? approvedBy;
  final String userRemarks;
  final String createdDate;
  final String lastModifiedDate;

  AttendanceModel({
    required this.attendanceId,
    required this.userId,
    required this.projectId,
    required this.date,
    required this.attendanceDate,
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
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: _parseInt(json['attendanceId']),
      userId: _parseInt(json['userId']),
      projectId: _parseInt(json['projectId']),
      date: json['date'] ?? '',
      attendanceDate: json['date'] ?? json['attendanceDate'] ?? '',
      attendanceType: json['attendanceType'] ?? '',
      attendance: _parseDouble(json['attendance']),
      attendanceLatt: _parseDouble(json['attendanceLatt']),
      attendanceLong: _parseDouble(json['attendanceLong']),
      distanceFromHQ: _parseDouble(json['distanceFromHQ']),
      picture: json['picture'] ?? '',
      status: json['status'] ?? '',
      approver: json['approver'] ?? '',
      approverRemarks: json['approverRemarks'],
      headquarterRemarks: json['headquarterRemarks'],
      approvedBy: json['approvedBy'] != null
          ? _parseInt(json['approvedBy'])
          : null,
      userRemarks: json['userRemarks'] ?? '',
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
      'projectId': projectId,
      'date': date,
      'attendanceDate': attendanceDate,
      'attendanceType': attendanceType,
      'attendance': attendance,
      'attendanceLatt': attendanceLatt,
      'attendanceLong': attendanceLong,
      'distanceFromHQ': distanceFromHQ,
      'picture': picture,
      'status': status,
      'approver': approver,
      'approverRemarks': approverRemarks,
      'headquarterRemarks': headquarterRemarks,
      'approvedBy': approvedBy,
      'userRemarks': userRemarks,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
    };
  }
}
