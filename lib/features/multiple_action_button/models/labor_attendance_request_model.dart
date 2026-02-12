import 'package:intl/intl.dart';

class LaborAttendanceRequestModel {
  final int projectId;
  final String laborType; // "CASUAL" or "CONTRACT"
  final String attendanceType; // "PUNCHIN"
  final String punchIn; // formatted datetime
  final double attendanceLatt;
  final double attendanceLong;
  final String? userRemarks;
  final String? picture; // base64 encoded image

  // CASUAL specific fields
  final String? laborName;
  final String? laborMobile;

  // CONTRACT specific fields
  final String? contractorName;
  final String? totalLabours;

  LaborAttendanceRequestModel({
    required this.projectId,
    required this.laborType,
    required this.attendanceLatt,
    required this.attendanceLong,
    this.attendanceType = 'PUNCHIN',
    String? punchIn,
    this.userRemarks,
    this.picture,
    this.laborName,
    this.laborMobile,
    this.contractorName,
    this.totalLabours,
  }) : punchIn =
           punchIn ?? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  /// Convert model → JSON (for API request)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "projectId": projectId,
      "laborType": laborType,
      "attendanceType": attendanceType,
      "punchIn": punchIn,
      "attendanceLatt": attendanceLatt,
      "attendanceLong": attendanceLong,
      "userRemarks": userRemarks,
      "picture": picture,
    };

    if (laborType == 'CASUAL') {
      data["laborName"] = laborName;
      data["laborMobile"] = laborMobile;
    } else if (laborType == 'CONTRACT') {
      data["contcatorName"] = contractorName; // API uses this spelling
      data["totalLabours"] = totalLabours;
    }

    return data;
  }
}
