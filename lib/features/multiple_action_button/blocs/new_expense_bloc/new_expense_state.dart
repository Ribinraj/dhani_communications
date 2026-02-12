part of 'new_expense_bloc.dart';

@immutable
sealed class NewExpenseState {}

final class NewExpenseInitial extends NewExpenseState {}

final class NewExpenseLoadingState extends NewExpenseState {}

final class NewExpenseSuccessState extends NewExpenseState {
  final String message;

  NewExpenseSuccessState({required this.message});
}

final class NewExpenseErrorState extends NewExpenseState {
  final String message;

  NewExpenseErrorState({required this.message});
}
