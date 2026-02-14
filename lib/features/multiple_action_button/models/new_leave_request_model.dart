/// Model for creating a new leave request
class NewLeaveRequestModel {
  final int projectId;
  final String fromDate;
  final String toDate;
  final double? leavesLatt;
  final double? leavesLong;
  final String leaveCategoryId;
  final String? userRemarks;
  final List<LeaveAttachment>? attachements;

  NewLeaveRequestModel({
    required this.projectId,
    required this.fromDate,
    required this.toDate,
    this.leavesLatt,
    this.leavesLong,
    required this.leaveCategoryId,
    this.userRemarks,
    this.attachements,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'projectId': projectId,
      'fromDate': fromDate,
      'toDate': toDate,
      'leaveCategoryId': leaveCategoryId,
    };

    if (leavesLatt != null) json['leavesLatt'] = leavesLatt;
    if (leavesLong != null) json['leavesLong'] = leavesLong;
    if (userRemarks != null && userRemarks!.isNotEmpty) {
      json['userRemarks'] = userRemarks;
    }
    if (attachements != null && attachements!.isNotEmpty) {
      json['attachements'] = attachements!.map((a) => a.toJson()).toList();
    }

    return json;
  }
}

/// Attachment model for leave submission
class LeaveAttachment {
  final String fileName;
  final String file;

  LeaveAttachment({required this.fileName, required this.file});

  Map<String, dynamic> toJson() {
    return {'fileName': fileName, 'file': file};
  }
}
