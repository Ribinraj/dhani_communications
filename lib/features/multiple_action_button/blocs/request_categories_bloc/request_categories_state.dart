part of 'request_categories_bloc.dart';

@immutable
sealed class RequestCategoriesState {}

final class RequestCategoriesInitial extends RequestCategoriesState {}

final class RequestCategoriesLoadingState extends RequestCategoriesState {}

final class RequestCategoriesSuccessState extends RequestCategoriesState {
  final List<RequestCategoryModel> categories;

  RequestCategoriesSuccessState({required this.categories});
}

final class RequestCategoriesErrorState extends RequestCategoriesState {
  final String message;

  RequestCategoriesErrorState({required this.message});
}
