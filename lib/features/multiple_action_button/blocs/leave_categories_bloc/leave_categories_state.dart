part of 'leave_categories_bloc.dart';

@immutable
sealed class LeaveCategoriesState {}

final class LeaveCategoriesInitial extends LeaveCategoriesState {}

final class LeaveCategoriesLoadingState extends LeaveCategoriesState {}

final class LeaveCategoriesSuccessState extends LeaveCategoriesState {
  final List<LeaveCategory> leavecategories;

  LeaveCategoriesSuccessState({required this.leavecategories});
}

final class LeaveCategoriesErrorState extends LeaveCategoriesState {
  final String message;

  LeaveCategoriesErrorState({required this.message});
}
