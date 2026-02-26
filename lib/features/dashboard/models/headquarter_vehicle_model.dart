/// Model for headquarter vehicle
class HeadquarterVehicleModel {
  final int vehicleId;
  final String vehicleNumber;
  final String vehicleType;

  HeadquarterVehicleModel({
    required this.vehicleId,
    required this.vehicleNumber,
    required this.vehicleType,
  });

  factory HeadquarterVehicleModel.fromJson(Map<String, dynamic> json) {
    return HeadquarterVehicleModel(
      vehicleId: json['vehicleId'] ?? 0,
      vehicleNumber: json['vehicleRegNumber'] ?? json['vehicleNumber'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
    };
  }
}
