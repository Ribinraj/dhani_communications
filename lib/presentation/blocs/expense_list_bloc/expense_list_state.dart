part of 'expense_list_bloc.dart';

@immutable
sealed class ExpenseListState {}

final class ExpenseListInitial extends ExpenseListState {}

final class ExpenseListLoadingState extends ExpenseListState {}

final class ExpenseListSuccessState extends ExpenseListState {
  final List<ExpenseModel> expensesList;

  ExpenseListSuccessState({required this.expensesList});
}

final class ExpenseListErrorState extends ExpenseListState {
  final String message;

  ExpenseListErrorState({required this.message});
}
