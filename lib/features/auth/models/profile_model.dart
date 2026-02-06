/// Model for user profile API response
class ProfileData {
  final String userId;
  final String employeeId;
  final String employeeName;
  final String mobileNumber;
  final String userRole;
  final String createdDate;
  final String lastModifiedDate;
  final ProfileDetails? profile;
  final int totalApprovals;
  final String totalNotifications;
  final ApprovalsData? approvals;

  ProfileData({
    required this.userId,
    required this.employeeId,
    required this.employeeName,
    required this.mobileNumber,
    required this.userRole,
    required this.createdDate,
    required this.lastModifiedDate,
    this.profile,
    required this.totalApprovals,
    required this.totalNotifications,
    this.approvals,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      userId: json['userId']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      employeeName: json['employeeName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      userRole: json['userRole'] ?? '',
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
      profile: json['profile'] != null
          ? ProfileDetails.fromJson(json['profile'])
          : null,
      totalApprovals: json['totalapprovals'] ?? 0,
      totalNotifications: json['totalNotifications']?.toString() ?? '0',
      approvals: json['approvals'] != null
          ? ApprovalsData.fromJson(json['approvals'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'mobileNumber': mobileNumber,
      'userRole': userRole,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'profile': profile?.toJson(),
      'totalapprovals': totalApprovals,
      'totalNotifications': totalNotifications,
      'approvals': approvals?.toJson(),
    };
  }
}

class ProfileDetails {
  final String? prefix;
  final String? gender;
  final String? designationId;
  final String? dateOfBirth;
  final String? dateOfJoining;
  final String? bloodGroup;
  final String? motherName;
  final String? fatherName;
  final String? adhaarNumber;
  final String? panNumber;
  final String? passportNumber;
  final String? uanEpf;
  final String? drivingLicenseNumber;
  final String? esicNumber;
  final String? personalInsurance;
  final String? healthInsurance;
  final String? accidentalInsurance;
  final String? pmjjInsurance;
  final String? pmjjby436;
  final String? pmsbi20;
  final String? paiSbi1000;
  final String? paiSbi500;
  final String? highestQualification;
  final String? martialStatus;
  final String? noOfChildren;
  final String? height;
  final String? weight;
  final String? presentAddress;
  final String? permanentAddess;
  final String? headquarterId;
  final String? leaveBalance;
  final String? profilePicture;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? headQuarterName;
  final String? designationName;

  ProfileDetails({
    this.prefix,
    this.gender,
    this.designationId,
    this.dateOfBirth,
    this.dateOfJoining,
    this.bloodGroup,
    this.motherName,
    this.fatherName,
    this.adhaarNumber,
    this.panNumber,
    this.passportNumber,
    this.uanEpf,
    this.drivingLicenseNumber,
    this.esicNumber,
    this.personalInsurance,
    this.healthInsurance,
    this.accidentalInsurance,
    this.pmjjInsurance,
    this.pmjjby436,
    this.pmsbi20,
    this.paiSbi1000,
    this.paiSbi500,
    this.highestQualification,
    this.martialStatus,
    this.noOfChildren,
    this.height,
    this.weight,
    this.presentAddress,
    this.permanentAddess,
    this.headquarterId,
    this.leaveBalance,
    this.profilePicture,
    this.createdDate,
    this.lastModifiedDate,
    this.headQuarterName,
    this.designationName,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) {
    return ProfileDetails(
      prefix: json['prefix']?.toString(),
      gender: json['gender']?.toString(),
      designationId: json['designationId']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      dateOfJoining: json['dateOfJoining']?.toString(),
      bloodGroup: json['bloodGroup']?.toString(),
      motherName: json['motherName']?.toString(),
      fatherName: json['fatherName']?.toString(),
      adhaarNumber: json['adhaarNumber']?.toString(),
      panNumber: json['panNumber']?.toString(),
      passportNumber: json['passportNumber']?.toString(),
      uanEpf: json['uan_epf']?.toString(),
      drivingLicenseNumber: json['drivingLicenseNumber']?.toString(),
      esicNumber: json['esicNumber']?.toString(),
      personalInsurance: json['personalInsurance']?.toString(),
      healthInsurance: json['healthInsurance']?.toString(),
      accidentalInsurance: json['accidentalInsurance']?.toString(),
      pmjjInsurance: json['pmjj_insurance']?.toString(),
      pmjjby436: json['pmjjby_436']?.toString(),
      pmsbi20: json['pmsbi_20']?.toString(),
      paiSbi1000: json['pai_sbi_1000']?.toString(),
      paiSbi500: json['pai_sbi_500']?.toString(),
      highestQualification: json['highestQualification']?.toString(),
      martialStatus: json['martialStatus']?.toString(),
      noOfChildren: json['noOfChildren']?.toString(),
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      presentAddress: json['presentAddress']?.toString(),
      permanentAddess: json['permanentAddess']?.toString(),
      headquarterId: json['headquarterId']?.toString(),
      leaveBalance: json['leaveBalance']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
      createdDate: json['createdDate']?.toString(),
      lastModifiedDate: json['lastModifiedDate']?.toString(),
      headQuarterName: json['headQuarterName']?.toString(),
      designationName: json['designationName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'gender': gender,
      'designationId': designationId,
      'dateOfBirth': dateOfBirth,
      'dateOfJoining': dateOfJoining,
      'bloodGroup': bloodGroup,
      'motherName': motherName,
      'fatherName': fatherName,
      'adhaarNumber': adhaarNumber,
      'panNumber': panNumber,
      'passportNumber': passportNumber,
      'uan_epf': uanEpf,
      'drivingLicenseNumber': drivingLicenseNumber,
      'esicNumber': esicNumber,
      'personalInsurance': personalInsurance,
      'healthInsurance': healthInsurance,
      'accidentalInsurance': accidentalInsurance,
      'pmjj_insurance': pmjjInsurance,
      'pmjjby_436': pmjjby436,
      'pmsbi_20': pmsbi20,
      'pai_sbi_1000': paiSbi1000,
      'pai_sbi_500': paiSbi500,
      'highestQualification': highestQualification,
      'martialStatus': martialStatus,
      'noOfChildren': noOfChildren,
      'height': height,
      'weight': weight,
      'presentAddress': presentAddress,
      'permanentAddess': permanentAddess,
      'headquarterId': headquarterId,
      'leaveBalance': leaveBalance,
      'profilePicture': profilePicture,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'headQuarterName': headQuarterName,
      'designationName': designationName,
    };
  }
}

class ApprovalsData {
  final String attendanceApprovals;
  final String laborAttendanceApprovals;
  final String expenseApprovals;
  final String leaveApprovals;
  final String dprApprovals;
  final String machineApprovals;

  ApprovalsData({
    required this.attendanceApprovals,
    required this.laborAttendanceApprovals,
    required this.expenseApprovals,
    required this.leaveApprovals,
    required this.dprApprovals,
    required this.machineApprovals,
  });

  factory ApprovalsData.fromJson(Map<String, dynamic> json) {
    return ApprovalsData(
      attendanceApprovals: json['attendanceApprovals']?.toString() ?? '0',
      laborAttendanceApprovals: json['laborAttendanceApprovals']?.toString() ?? '0',
      expenseApprovals: json['expenseApprovals']?.toString() ?? '0',
      leaveApprovals: json['leaveApprovals']?.toString() ?? '0',
      dprApprovals: json['dprApprovals']?.toString() ?? '0',
      machineApprovals: json['machineApprovals']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceApprovals': attendanceApprovals,
      'laborAttendanceApprovals': laborAttendanceApprovals,
      'expenseApprovals': expenseApprovals,
      'leaveApprovals': leaveApprovals,
      'dprApprovals': dprApprovals,
      'machineApprovals': machineApprovals,
    };
  }
}
