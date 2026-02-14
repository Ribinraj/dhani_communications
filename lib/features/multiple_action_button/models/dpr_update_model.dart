class DprUpdateModel {
  final int projectId;
  final int dprId;
  final String progressDate;
  final double progressQuantity;
  final String userRemarks;

  DprUpdateModel({
    required this.projectId,
    required this.dprId,
    required this.progressDate,
    required this.progressQuantity,
    required this.userRemarks,
  });

  /// Convert Model -> JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "projectId": projectId,
      "dprId": dprId,
      "progressDate": progressDate,
      "progressQuantity": progressQuantity,
      "userRemarks": userRemarks,
    };
  }

  /// Convert JSON -> Model (if needed)
  factory DprUpdateModel.fromJson(Map<String, dynamic> json) {
    return DprUpdateModel(
      projectId: json['projectId'],
      dprId: json['dprId'],
      progressDate: json['progressDate'],
      progressQuantity: (json['progressQuantity'] as num).toDouble(),
      userRemarks: json['userRemarks'],
    );
  }
}
