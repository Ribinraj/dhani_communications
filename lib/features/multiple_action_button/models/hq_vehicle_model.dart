/// Model for headquarter vehicle from login/headquartervehicles API
class HqVehicleModel {
  final String vehicleId;
  final String headQuarterId;
  final String vehicleType;
  final String vehicleMakeModel;
  final String vehicleRegNumber;
  final String vehicleRegValidity;
  final String vehiclePucNumber;
  final String vehiclePucValidity;
  final String vehicleInsuranceNumber;
  final String vehicleInsuranceValidity;
  final String vehicleLastOilServiceDate;
  final String vehicleLastServiceDate;
  final String vehicleLastServiceKm;
  final String? picture;
  final String ownership;
  final String createdDate;
  final String lastModifiedDate;

  HqVehicleModel({
    required this.vehicleId,
    required this.headQuarterId,
    required this.vehicleType,
    required this.vehicleMakeModel,
    required this.vehicleRegNumber,
    required this.vehicleRegValidity,
    required this.vehiclePucNumber,
    required this.vehiclePucValidity,
    required this.vehicleInsuranceNumber,
    required this.vehicleInsuranceValidity,
    required this.vehicleLastOilServiceDate,
    required this.vehicleLastServiceDate,
    required this.vehicleLastServiceKm,
    this.picture,
    required this.ownership,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory HqVehicleModel.fromJson(Map<String, dynamic> json) {
    return HqVehicleModel(
      vehicleId: json['vehicleId']?.toString() ?? '',
      headQuarterId: json['headQuarterId']?.toString() ?? '',
      vehicleType: json['vehicleType'] ?? '',
      vehicleMakeModel: json['vehicleMakeModel'] ?? '',
      vehicleRegNumber: json['vehicleRegNumber'] ?? '',
      vehicleRegValidity: json['vehicleRegValidity'] ?? '',
      vehiclePucNumber: json['vehiclePucNumber'] ?? '',
      vehiclePucValidity: json['vehiclePucValidity'] ?? '',
      vehicleInsuranceNumber: json['vehicleInsuranceNumber'] ?? '',
      vehicleInsuranceValidity: json['vehicleInsuranceValidity'] ?? '',
      vehicleLastOilServiceDate: json['vehicleLastOilServiceDate'] ?? '',
      vehicleLastServiceDate: json['vehicleLastServiceDate'] ?? '',
      vehicleLastServiceKm: json['vehicleLastServiceKm']?.toString() ?? '',
      picture: json['picture'],
      ownership: json['ownership']?.toString() ?? '',
      createdDate: json['createdDate'] ?? '',
      lastModifiedDate: json['lastModifiedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'headQuarterId': headQuarterId,
      'vehicleType': vehicleType,
      'vehicleMakeModel': vehicleMakeModel,
      'vehicleRegNumber': vehicleRegNumber,
      'vehicleRegValidity': vehicleRegValidity,
      'vehiclePucNumber': vehiclePucNumber,
      'vehiclePucValidity': vehiclePucValidity,
      'vehicleInsuranceNumber': vehicleInsuranceNumber,
      'vehicleInsuranceValidity': vehicleInsuranceValidity,
      'vehicleLastOilServiceDate': vehicleLastOilServiceDate,
      'vehicleLastServiceDate': vehicleLastServiceDate,
      'vehicleLastServiceKm': vehicleLastServiceKm,
      'picture': picture,
      'ownership': ownership,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
    };
  }
}
