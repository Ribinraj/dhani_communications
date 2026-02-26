part of 'fetch_approvel_expense_bloc.dart';

@immutable
sealed class FetchApprovelExpenseState {}

final class FetchApprovelExpenseInitial extends FetchApprovelExpenseState {}

final class FetchApprovelExpenseLoadingState
    extends FetchApprovelExpenseState {}

final class FetchApprovelExpensesSuccessSate extends FetchApprovelExpenseState {
  final List<ApprovelsExpensemodel> expenses;

  FetchApprovelExpensesSuccessSate({required this.expenses});
}

final class FetchApprovelExpensesErrorState extends FetchApprovelExpenseState {
  final String message;

  FetchApprovelExpensesErrorState({required this.message});
}
