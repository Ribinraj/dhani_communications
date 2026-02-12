import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/leave_categories_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'leave_categories_event.dart';
part 'leave_categories_state.dart';

class LeaveCategoriesBloc
    extends Bloc<LeaveCategoriesEvent, LeaveCategoriesState> {
  final Multiactionrepo repository;
  LeaveCategoriesBloc({required this.repository})
    : super(LeaveCategoriesInitial()) {
    on<LeaveCategoriesEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LeaveCategoriesFetchingInitialEvent>(fetchleavecategories);
  }

FutureOr<void> fetchleavecategories(
  LeaveCategoriesFetchingInitialEvent event,
  Emitter<LeaveCategoriesState> emit,
) async {
  emit(LeaveCategoriesLoadingState());
  
  final response = await repository.getleavecategories();
  
  if (!response.error && response.status == 200) {
    emit(LeaveCategoriesSuccessState(leavecategories: response.data!));
  } else {
    emit(LeaveCategoriesErrorState(message: response.message));
  }
}
}
