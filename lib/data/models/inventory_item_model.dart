class InventoryItem {
  final String? inventoryId;
  final String? schCode;
  final String? projectId;
  final String? itemName;
  final String? issuedFrom;
  final String? issuedDate;
  final String? receivedFrom;
  final String? qty;
  final String? unit;
  final String? headquarter;
  final String? userId;
  final String? status;
  final String? transferTo;
  final String? returnedTo;
  final String? returnToName;
  final String? transferDate;
  final String? returnDate;
  final String? transferRemarks;
  final String? returnRemarks;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? projectName;

  InventoryItem({
    this.inventoryId,
    this.schCode,
    this.projectId,
    this.itemName,
    this.issuedFrom,
    this.issuedDate,
    this.receivedFrom,
    this.qty,
    this.unit,
    this.headquarter,
    this.userId,
    this.status,
    this.transferTo,
    this.returnedTo,
    this.returnToName,
    this.transferDate,
    this.returnDate,
    this.transferRemarks,
    this.returnRemarks,
    this.createdDate,
    this.lastModifiedDate,
    this.projectName,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      inventoryId: json['inventoryId']?.toString(),
      schCode: json['schCode']?.toString(),
      projectId: json['projectId']?.toString(),
      itemName: json['itemName']?.toString(),
      issuedFrom: json['issuedFrom']?.toString(),
      issuedDate: json['issuedDate']?.toString(),
      receivedFrom: json['receivedFrom']?.toString(),
      qty: json['qty']?.toString(),
      unit: json['unit']?.toString(),
      headquarter: json['headquarter']?.toString(),
      userId: json['userId']?.toString(),
      status: json['status']?.toString(),
      transferTo: json['transferTo']?.toString(),
      returnedTo: json['returnedTo']?.toString(),
      returnToName: json['returnToName']?.toString(),
      transferDate: json['transferDate']?.toString(),
      returnDate: _sanitizeDate(json['returnDate']),
      transferRemarks: json['transferRemarks']?.toString(),
      returnRemarks: json['returnRemarks']?.toString(),
      createdDate: json['createdDate']?.toString(),
      lastModifiedDate: json['lastModifiedDate']?.toString(),
      projectName: json['projectName']?.toString(),
    );
  }
    static String? _sanitizeDate(dynamic value) {
    if (value == null || value == "0000-00-00" || value == "") {
      return null;
    }
    return value.toString();
  }
}