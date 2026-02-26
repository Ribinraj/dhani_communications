class AssetTransferModel {
  final int assetId;
  final String transferTo;
  final String remarks;

  AssetTransferModel({
    required this.assetId,
    required this.transferTo,
    required this.remarks,
  });

  /// Convert Model -> JSON (For API request)
  Map<String, dynamic> toJson() {
    return {"assetId": assetId, "transferTo": transferTo, "remarks": remarks};
  }

  /// Convert JSON -> Model (If API returns response)
  factory AssetTransferModel.fromJson(Map<String, dynamic> json) {
    return AssetTransferModel(
      assetId: json['assetId'],
      transferTo: json['transferTo'],
      remarks: json['remarks'],
    );
  }
}
