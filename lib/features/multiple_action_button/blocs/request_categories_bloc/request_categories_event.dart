part of 'request_categories_bloc.dart';

@immutable
sealed class RequestCategoriesEvent {}

final class FetchRequestCategoriesEvent extends RequestCategoriesEvent {}
