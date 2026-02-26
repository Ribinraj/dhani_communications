class InventoryConsumptionModel {
  final int inventoryId;
  final double qty;
  final String date;
  final String remarks;

  InventoryConsumptionModel({
    required this.inventoryId,
    required this.qty,
    required this.date,
    required this.remarks,
  });

  /// Convert Model -> JSON (For API request)
  Map<String, dynamic> toJson() {
    return {
      "inventoryId": inventoryId,
      "qty": qty,
      "date": date,
      "remarks": remarks,
    };
  }

  /// Convert JSON -> Model (If API returns response)
  factory InventoryConsumptionModel.fromJson(Map<String, dynamic> json) {
    return InventoryConsumptionModel(
      inventoryId: json['inventoryId'],
      qty: (json['qty'] as num).toDouble(),
      date: json['date'],
      remarks: json['remarks'],
    );
  }
}
