class LeaveCategory {
  final String? leaveCategoryId;
  final String? leaveCategory;
  final DateTime? createdDate;
  final DateTime? lastModifiedDate;

  LeaveCategory({
    this.leaveCategoryId,
    this.leaveCategory,
    this.createdDate,
    this.lastModifiedDate,
  });

  factory LeaveCategory.fromJson(Map<String, dynamic> json) {
    return LeaveCategory(
      leaveCategoryId: json['leaveCategoryId']?.toString(),
      leaveCategory: json['leaveCategory'],
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
      lastModifiedDate: json['lastModifiedDate'] != null
          ? DateTime.tryParse(json['lastModifiedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveCategoryId': leaveCategoryId,
      'leaveCategory': leaveCategory,
      'createdDate': createdDate?.toIso8601String(),
      'lastModifiedDate': lastModifiedDate?.toIso8601String(),
    };
  }
}
