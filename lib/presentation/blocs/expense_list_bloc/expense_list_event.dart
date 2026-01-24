part of 'expense_list_bloc.dart';

@immutable
sealed class ExpenseListEvent {}

class FetchExpenseListEvent extends ExpenseListEvent {
  final int projectId;
  final String startDate;
  final String endDate;

  FetchExpenseListEvent({
    required this.projectId,
    required this.startDate,
    required this.endDate,
  });
}
