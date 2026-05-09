part of 'cash_balance_bloc.dart';

@immutable
sealed class CashBalanceEvent {}

class FetchCashBalanceEvent extends CashBalanceEvent {}

class FetchCashTransactionsEvent extends CashBalanceEvent {}
