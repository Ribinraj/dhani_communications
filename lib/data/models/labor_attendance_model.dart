/// Model for labor attendance record
class LaborAttendanceModel {
  final int laborAttendanceId;
  final String laborName;
  final String laborMobile;
  final String laborType;
  final String attendanceDate;
  final String punchInTime;
  final String punchOutTime;
  final String status;

  LaborAttendanceModel({
    required this.laborAttendanceId,
    required this.laborName,
    required this.laborMobile,
    required this.laborType,
    required this.attendanceDate,
    required this.punchInTime,
    required this.punchOutTime,
    required this.status,
  });

  factory LaborAttendanceModel.fromJson(Map<String, dynamic> json) {
    return LaborAttendanceModel(
      laborAttendanceId: json['laborAttendanceId'] ?? 0,
      laborName: json['laborName'] ?? '',
      laborMobile: json['laborMobile'] ?? '',
      laborType: json['laborType'] ?? '',
      attendanceDate: json['attendanceDate'] ?? '',
      punchInTime: json['punchInTime'] ?? '',
      punchOutTime: json['punchOutTime'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'laborAttendanceId': laborAttendanceId,
      'laborName': laborName,
      'laborMobile': laborMobile,
      'laborType': laborType,
      'attendanceDate': attendanceDate,
      'punchInTime': punchInTime,
      'punchOutTime': punchOutTime,
      'status': status,
    };
  }
}
