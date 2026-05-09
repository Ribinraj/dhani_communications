part of 'cash_balance_bloc.dart';

@immutable
sealed class CashBalanceState {}

final class CashBalanceInitial extends CashBalanceState {}

// ── Balance States ────────────────────────────────────────────────────────────
final class CashBalanceLoadingState extends CashBalanceState {}

final class CashBalanceSuccessState extends CashBalanceState {
  final String balance;

  CashBalanceSuccessState({required this.balance});
}

final class CashBalanceErrorState extends CashBalanceState {
  final String message;

  CashBalanceErrorState({required this.message});
}

// ── Transactions States ───────────────────────────────────────────────────────
final class CashTransactionsLoadingState extends CashBalanceState {}

final class CashTransactionsSuccessState extends CashBalanceState {
  final String balance;
  final List<CashTransactionModel> transactions;

  CashTransactionsSuccessState({
    required this.balance,
    required this.transactions,
  });
}

final class CashTransactionsErrorState extends CashBalanceState {
  final String message;

  CashTransactionsErrorState({required this.message});
}
