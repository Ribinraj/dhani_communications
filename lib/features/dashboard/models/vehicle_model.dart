/// Full vehicle model matching the login/vehicles API response
class VehicleModel {
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

  VehicleModel({
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

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleId: json['vehicleId']?.toString() ?? '',
      headQuarterId: json['headQuarterId']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      vehicleMakeModel: json['vehicleMakeModel']?.toString() ?? '',
      vehicleRegNumber: json['vehicleRegNumber']?.toString() ?? '',
      vehicleRegValidity: json['vehicleRegValidity']?.toString() ?? '',
      vehiclePucNumber: json['vehiclePucNumber']?.toString() ?? '',
      vehiclePucValidity: json['vehiclePucValidity']?.toString() ?? '',
      vehicleInsuranceNumber:
          json['vehicleInsuranceNumber']?.toString() ?? '',
      vehicleInsuranceValidity:
          json['vehicleInsuranceValidity']?.toString() ?? '',
      vehicleLastOilServiceDate:
          json['vehicleLastOilServiceDate']?.toString() ?? '',
      vehicleLastServiceDate:
          json['vehicleLastServiceDate']?.toString() ?? '',
      vehicleLastServiceKm:
          json['vehicleLastServiceKm']?.toString() ?? '',
      picture: json['picture']?.toString(),
      ownership: json['ownership']?.toString() ?? '',
      createdDate: json['createdDate']?.toString() ?? '',
      lastModifiedDate: json['lastModifiedDate']?.toString() ?? '',
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
