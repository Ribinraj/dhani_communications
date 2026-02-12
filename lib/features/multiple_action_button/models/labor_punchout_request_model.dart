import 'package:intl/intl.dart';

class LaborPunchOutRequestModel {
  final String attendanceId;
  final String attendanceType; // "PUNCHOUT"
  final String punchOut; // formatted datetime
  final String? punchOutPicture; // base64 encoded image
  final String? wages; // optional, only for CASUAL type

  LaborPunchOutRequestModel({
    required this.attendanceId,
    this.attendanceType = 'PUNCHOUT',
    String? punchOut,
    this.punchOutPicture,
    this.wages,
  }) : punchOut =
           punchOut ?? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "attendanceId": attendanceId,
      "attendanceType": attendanceType,
      "punchOut": punchOut,
      "punchOutPicture": punchOutPicture,
    };

    if (wages != null && wages!.isNotEmpty) {
      data["wages"] = wages;
    }

    return data;
  }
}
