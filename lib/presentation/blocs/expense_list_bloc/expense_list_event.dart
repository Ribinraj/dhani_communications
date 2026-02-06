part of 'expense_list_bloc.dart';

@immutable
sealed class ExpenseListEvent {}

class FetchExpenseListEvent extends ExpenseListEvent {
  final String? startDate;
  final String? endDate;

  FetchExpenseListEvent({this.startDate, this.endDate});
}
