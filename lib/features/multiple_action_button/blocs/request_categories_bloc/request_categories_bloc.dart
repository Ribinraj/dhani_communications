import 'dart:async';

import 'package:dhani_communications/features/multiple_action_button/models/request_category_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'request_categories_event.dart';
part 'request_categories_state.dart';

class RequestCategoriesBloc
    extends Bloc<RequestCategoriesEvent, RequestCategoriesState> {
  final Multiactionrepo repository;

  RequestCategoriesBloc({required this.repository})
    : super(RequestCategoriesInitial()) {
    on<FetchRequestCategoriesEvent>(_fetchRequestCategories);
  }

  FutureOr<void> _fetchRequestCategories(
    FetchRequestCategoriesEvent event,
    Emitter<RequestCategoriesState> emit,
  ) async {
    emit(RequestCategoriesLoadingState());
    try {
      final response = await repository.getRequestCategories();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(RequestCategoriesSuccessState(categories: response.data!));
      } else {
        emit(RequestCategoriesErrorState(message: response.message));
      }
    } catch (e) {
      emit(RequestCategoriesErrorState(message: e.toString()));
    }
  }
}
