import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_leave_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'new_leave_event.dart';
part 'new_leave_state.dart';

class NewLeaveBloc extends Bloc<NewLeaveEvent, NewLeaveState> {
  final Multiactionrepo repository;

  NewLeaveBloc({required this.repository}) : super(NewLeaveInitial()) {
    on<SubmitNewLeaveEvent>(_onSubmitLeave);
  }

  FutureOr<void> _onSubmitLeave(
    SubmitNewLeaveEvent event,
    Emitter<NewLeaveState> emit,
  ) async {
    emit(NewLeaveLoadingState());
    try {
      final response = await repository.createNewLeave(leave: event.leave);
      if (!response.error && response.status == 200) {
        emit(NewLeaveSuccessState(message: response.message));
      } else {
        emit(NewLeaveErrorState(message: response.message));
      }
    } catch (e) {
      emit(NewLeaveErrorState(message: e.toString()));
    }
  }
}
