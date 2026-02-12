part of 'expense_categories_bloc.dart';

@immutable
sealed class ExpenseCategoriesEvent {}

class FetchExpenseCategoriesEvent extends ExpenseCategoriesEvent {}
