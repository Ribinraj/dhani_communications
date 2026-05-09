class MachineTypeModel {
  final String machineryId;
  final String machineName;
  final String modifiedAt;

  MachineTypeModel({
    required this.machineryId,
    required this.machineName,
    required this.modifiedAt,
  });

  factory MachineTypeModel.fromJson(Map<String, dynamic> json) {
    return MachineTypeModel(
      machineryId: json['machineryId']?.toString() ?? '',
      machineName: json['machineName']?.toString().trim() ?? '',
      modifiedAt: json['modified_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'machineryId': machineryId,
      'machineName': machineName,
      'modified_at': modifiedAt,
    };
  }
}
