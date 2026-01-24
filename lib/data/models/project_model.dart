/// Model for project assigned to user
class ProjectModel {
  final int projectId;
  final String projectName;
  final String projectCode;

  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.projectCode,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'] ?? 0,
      projectName: json['projectName'] ?? '',
      projectCode: json['projectCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'projectCode': projectCode,
    };
  }
}
