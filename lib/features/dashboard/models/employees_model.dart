class EmployeeModel {
  final String employeeId;
  final String employeeName;

  EmployeeModel({
    required this.employeeId,
    required this.employeeName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
    };
  }
}


// class EmployeesModel {
//   final String userId;
//   final String employeeId;
//   final String employeeName;
//   final String mobileNumber;
//   final String userPassword;
//   final String userStatus;
//   final String userRole;
//   final String? otp;
//   final String pushToken;
//   final String createdDate;
//   final String lastModifiedDate;

//   EmployeesModel({
//     required this.userId,
//     required this.employeeId,
//     required this.employeeName,
//     required this.mobileNumber,
//     required this.userPassword,
//     required this.userStatus,
//     required this.userRole,
//     this.otp,
//     required this.pushToken,
//     required this.createdDate,
//     required this.lastModifiedDate,
//   });

//   factory EmployeesModel.fromJson(Map<String, dynamic> json) {
//     return EmployeesModel(
//       userId: json['userId'] ?? '',
//       employeeId: json['employeeId'] ?? '',
//       employeeName: json['employeeName'] ?? '',
//       mobileNumber: json['mobileNumber'] ?? '',
//       userPassword: json['userPassword'] ?? '',
//       userStatus: json['userStatus'] ?? '',
//       userRole: json['userRole'] ?? '',
//       otp: json['otp'],
//       pushToken: json['pushToken'] ?? '',
//       createdDate: json['createdDate'] ?? '',
//       lastModifiedDate: json['lastModifiedDate'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'employeeId': employeeId,
//       'employeeName': employeeName,
//       'mobileNumber': mobileNumber,
//       'userPassword': userPassword,
//       'userStatus': userStatus,
//       'userRole': userRole,
//       'otp': otp,
//       'pushToken': pushToken,
//       'createdDate': createdDate,
//       'lastModifiedDate': lastModifiedDate,
//     };
//   }
// }
