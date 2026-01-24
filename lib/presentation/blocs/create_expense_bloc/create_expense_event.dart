part of 'create_expense_bloc.dart';

@immutable
sealed class CreateExpenseEvent {}

class SubmitExpenseEvent extends CreateExpenseEvent {
  final int projectId;
  final String expenseDate;
  final int expenseCategoryId;
  final double expenseAmount;
  final int? vehicleId;
  final int? fuelFillKm;
  final String? userRemarks;
  final List<ExpenseAttachment>? attachements;

  SubmitExpenseEvent({
    required this.projectId,
    required this.expenseDate,
    required this.expenseCategoryId,
    required this.expenseAmount,
    this.vehicleId,
    this.fuelFillKm,
    this.userRemarks,
    this.attachements,
  });
}
