/// Model for attendance check response from attendance/check API
class AttendanceCheckResponseModel {
  final String status;
  final String attendanceType;

  AttendanceCheckResponseModel({
    required this.status,
    required this.attendanceType,
  });

  factory AttendanceCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceCheckResponseModel(
      status: json['status'] ?? '',
      attendanceType: json['attendanceTye'] ?? '',
    );
  }

  /// Whether attendance can be marked (status is ACCEPT)
  bool get canMark => status == 'ACCEPT';
}
