/// Model for project assigned to user
class ProjectModel {
  final int projectId;
  final String projectName;
  final String projectLocation;
  final int assignmentId;
  final int userId;
  final String createdDate;
  final String lastModifiedDate;

  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.projectLocation,
    required this.assignmentId,
    required this.userId,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: _parseInt(json['projectId']),
      projectName: json['projectName'] ?? '',
      projectLocation: json['projectLocation'] ?? '',
      assignmentId: _parseInt(json['assignmentId']),
      userId: _parseInt(json['userId']),
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
    );
  }

  /// Parse int from dynamic value (handles both int and String)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'projectLocation': projectLocation,
      'assignmentId': assignmentId,
      'userId': userId,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
    };
  }
}
