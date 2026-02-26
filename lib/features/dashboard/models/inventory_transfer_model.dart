class InventoryTransferModel {
  final int inventoryId;
  final String transferTo;
  final String transferRemarks;

  InventoryTransferModel({
    required this.inventoryId,
    required this.transferTo,
    required this.transferRemarks,
  });

  /// Convert Model -> JSON (For API request)
  Map<String, dynamic> toJson() {
    return {
      "inventoryId": inventoryId,
      "transferTo": transferTo,
      "transferRemarks": transferRemarks,
    };
  }

  /// Convert JSON -> Model (If API returns response)
  factory InventoryTransferModel.fromJson(Map<String, dynamic> json) {
    return InventoryTransferModel(
      inventoryId: json['inventoryId'],
      transferTo: json['transferTo'],
      transferRemarks: json['transferRemarks'],
    );
  }
}
