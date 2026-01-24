/// Model for attendance check response
class AttendanceCheckModel {
  final bool canMarkAttendance;
  final String message;

  AttendanceCheckModel({
    required this.canMarkAttendance,
    required this.message,
  });

  factory AttendanceCheckModel.fromJson(Map<String, dynamic> json) {
    return AttendanceCheckModel(
      canMarkAttendance: json['canMarkAttendance'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canMarkAttendance': canMarkAttendance,
      'message': message,
    };
  }
}
