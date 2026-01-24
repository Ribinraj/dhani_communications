part of 'create_expense_bloc.dart';

@immutable
sealed class CreateExpenseState {}

final class CreateExpenseInitial extends CreateExpenseState {}

final class CreateExpenseLoadingState extends CreateExpenseState {}

final class CreateExpenseSuccessState extends CreateExpenseState {
  final int? expenseId;
  final String message;

  CreateExpenseSuccessState({this.expenseId, required this.message});
}

final class CreateExpenseErrorState extends CreateExpenseState {
  final String message;

  CreateExpenseErrorState({required this.message});
}
