/// Model for a single cash transaction
class CashTransactionModel {
  final String transactionId;
  final String userId;
  final String cashId;
  final String transactionType; // CREDIT or DEBIT
  final String amount;
  final String notes;
  final String createdAt;
  final String modifiedAt;

  CashTransactionModel({
    required this.transactionId,
    required this.userId,
    required this.cashId,
    required this.transactionType,
    required this.amount,
    required this.notes,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory CashTransactionModel.fromJson(Map<String, dynamic> json) {
    // created_at can be an object with a "date" key
    String createdAtStr = '';
    final raw = json['created_at'];
    if (raw is Map<String, dynamic>) {
      createdAtStr = raw['date']?.toString() ?? '';
    } else if (raw is String) {
      createdAtStr = raw;
    }

    return CashTransactionModel(
      transactionId: json['transactionId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      cashId: json['cashId']?.toString() ?? '',
      transactionType: json['transactionType']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      notes: json['notes']?.toString() ?? '',
      createdAt: createdAtStr,
      modifiedAt: json['modified_at']?.toString() ?? '',
    );
  }

  bool get isCredit => transactionType.toUpperCase() == 'CREDIT';
}
