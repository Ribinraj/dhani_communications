part of 'expense_categories_bloc.dart';

@immutable
sealed class ExpenseCategoriesState {}

final class ExpenseCategoriesInitial extends ExpenseCategoriesState {}

final class ExpenseCategoriesLoadingState extends ExpenseCategoriesState {}

final class ExpenseCategoriesSuccessState extends ExpenseCategoriesState {
  final List<ExpenseCategoryModel> categories;

  ExpenseCategoriesSuccessState({required this.categories});
}

final class ExpenseCategoriesErrorState extends ExpenseCategoriesState {
  final String message;

  ExpenseCategoriesErrorState({required this.message});
}
