/// Model for punch in list (labors who have punched in)
class PunchInListModel {
  final String attendanceId;
  final String laborName;
  final String laborMobile;
  final String laborType;
  final String contcatorName;
  final String punchInTime;
  final String attendanceDate;

  PunchInListModel({
    required this.attendanceId,
    required this.laborName,
    required this.laborMobile,
    required this.laborType,
    required this.contcatorName,
    required this.punchInTime,
    required this.attendanceDate,
  });

  factory PunchInListModel.fromJson(Map<String, dynamic> json) {
    return PunchInListModel(
      attendanceId: json['attendanceId'] ?? '',
      laborName: json['laborName'] ?? '',
      laborMobile: json['laborMobile'] ?? '',
      laborType: json['laborType'] ?? '',
      contcatorName: json['contcatorName'] ?? '',
      punchInTime: json['punchInTime'] ?? '',
      attendanceDate: json['attendanceDate'] ?? '',
    );
  }

  /// Display label for dropdown: "CONTRACT ( contractorName )" or "CASUAL ( laborName )"
  String get displayLabel {
    if (laborType == 'CONTRACT') {
      return '$laborType ( $contcatorName )';
    }
    return '$laborType ( $laborName )';
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId':  "attendanceId",
      'laborName': laborName,
      'laborMobile': laborMobile,
      'laborType': laborType,
      'contcatorName': contcatorName,
      'punchInTime': punchInTime,
      'attendanceDate': attendanceDate,
    };
  }
}
