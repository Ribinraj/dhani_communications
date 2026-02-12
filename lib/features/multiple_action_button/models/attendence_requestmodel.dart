class AttendanceRequestModel {
  final int projectId;
  final double attendance;
  final double attendanceLatt;
  final double attendanceLong;
  final String? userRemarks;
  final String? picture; // base64 encoded image
  final String attendanceType;

  AttendanceRequestModel({
    required this.projectId,
    required this.attendance,
    required this.attendanceLatt,
    required this.attendanceLong,
    required this.attendanceType,
    this.userRemarks,
    this.picture,
  });

  /// Convert model → JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "projectId": projectId,
      "attendance": attendance,
      "attendanceLatt": attendanceLatt,
      "attendanceLong": attendanceLong,
      "attendanceType": attendanceType,
      "userRemarks": userRemarks,
      "picture": picture,
    };
  }
}
