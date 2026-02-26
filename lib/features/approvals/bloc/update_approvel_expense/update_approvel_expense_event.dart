part of 'update_approvel_expense_bloc.dart';

@immutable
sealed class UpdateApprovelExpenseEvent {}

final class ApproveExpenseEvent extends UpdateApprovelExpenseEvent {
  final String expenseId;

  ApproveExpenseEvent({required this.expenseId});
}

final class RejectExpenseEvent extends UpdateApprovelExpenseEvent {
  final String expenseId;
  final String approverRemarks;

  RejectExpenseEvent({required this.expenseId, required this.approverRemarks});
}
