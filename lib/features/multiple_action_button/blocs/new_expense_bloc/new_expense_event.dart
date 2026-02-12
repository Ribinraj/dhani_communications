part of 'new_expense_bloc.dart';

@immutable
sealed class NewExpenseEvent {}

class SubmitNewExpenseEvent extends NewExpenseEvent {
  final NewExpenseRequestModel expense;

  SubmitNewExpenseEvent({required this.expense});
}
