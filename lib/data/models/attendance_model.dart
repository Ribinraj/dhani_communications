/// Model for attendance record
class AttendanceModel {
  final int attendanceId;
  final String attendanceDate;
  final double attendance;
  final double attendanceLatt;
  final double attendanceLong;
  final String userRemarks;
  final String status;
  final String picture;

  AttendanceModel({
    required this.attendanceId,
    required this.attendanceDate,
    required this.attendance,
    required this.attendanceLatt,
    required this.attendanceLong,
    required this.userRemarks,
    required this.status,
    required this.picture,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: json['attendanceId'] ?? 0,
      attendanceDate: json['attendanceDate'] ?? '',
      attendance: (json['attendance'] ?? 0).toDouble(),
      attendanceLatt: (json['attendanceLatt'] ?? 0).toDouble(),
      attendanceLong: (json['attendanceLong'] ?? 0).toDouble(),
      userRemarks: json['userRemarks'] ?? '',
      status: json['status'] ?? '',
      picture: json['picture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'attendanceDate': attendanceDate,
      'attendance': attendance,
      'attendanceLatt': attendanceLatt,
      'attendanceLong': attendanceLong,
      'userRemarks': userRemarks,
      'status': status,
      'picture': picture,
    };
  }
}
