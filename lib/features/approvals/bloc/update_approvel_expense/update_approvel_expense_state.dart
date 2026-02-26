part of 'update_approvel_expense_bloc.dart';

@immutable
sealed class UpdateApprovelExpenseState {}

final class UpdateApprovelExpenseInitial extends UpdateApprovelExpenseState {}

final class UpdateApprovelExpenseLoadingState
    extends UpdateApprovelExpenseState {}

final class UpdateApprovelExpenseSuccessState
    extends UpdateApprovelExpenseState {
  final String message;

  UpdateApprovelExpenseSuccessState({required this.message});
}

final class UpdateApprovelExpenseErrorState extends UpdateApprovelExpenseState {
  final String message;

  UpdateApprovelExpenseErrorState({required this.message});
}
