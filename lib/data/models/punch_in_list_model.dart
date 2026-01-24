/// Model for punch in list (labors who have punched in)
class PunchInListModel {
  final int laborAttendanceId;
  final String laborName;
  final String laborMobile;
  final String punchInTime;
  final String attendanceDate;

  PunchInListModel({
    required this.laborAttendanceId,
    required this.laborName,
    required this.laborMobile,
    required this.punchInTime,
    required this.attendanceDate,
  });

  factory PunchInListModel.fromJson(Map<String, dynamic> json) {
    return PunchInListModel(
      laborAttendanceId: json['laborAttendanceId'] ?? 0,
      laborName: json['laborName'] ?? '',
      laborMobile: json['laborMobile'] ?? '',
      punchInTime: json['punchInTime'] ?? '',
      attendanceDate: json['attendanceDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'laborAttendanceId': laborAttendanceId,
      'laborName': laborName,
      'laborMobile': laborMobile,
      'punchInTime': punchInTime,
      'attendanceDate': attendanceDate,
    };
  }
}
