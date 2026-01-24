/// Model for vehicle assigned to user
class VehicleModel {
  final int vehicleId;
  final String vehicleNumber;
  final String vehicleType;
  final String model;

  VehicleModel({
    required this.vehicleId,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.model,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleId: json['vehicleId'] ?? 0,
      vehicleNumber: json['vehicleNumber'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      model: json['model'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'model': model,
    };
  }
}
