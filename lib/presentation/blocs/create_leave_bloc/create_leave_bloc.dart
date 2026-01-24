import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'create_leave_event.dart';
part 'create_leave_state.dart';

class CreateLeaveBloc extends Bloc<CreateLeaveEvent, CreateLeaveState> {
  final Apprepo repository;

  CreateLeaveBloc({required this.repository}) : super(CreateLeaveInitial()) {
    on<SubmitLeaveEvent>(_onSubmitLeave);
  }

  FutureOr<void> _onSubmitLeave(
    SubmitLeaveEvent event,
    Emitter<CreateLeaveState> emit,
  ) async {
    emit(CreateLeaveLoadingState());
    try {
      final response = await repository.createLeave(
        projectId: event.projectId,
        leaveCategoryId: event.leaveCategoryId,
        leaveFromDate: event.leaveFromDate,
        leaveToDate: event.leaveToDate,
        userRemarks: event.userRemarks,
        leaveLatt: event.leaveLatt,
        leaveLong: event.leaveLong,
        picture: event.picture,
      );
      if (!response.error && response.status == 200) {
        emit(CreateLeaveSuccessState(
          leaveId: response.data,
          message: response.message,
        ));
      } else {
        emit(CreateLeaveErrorState(message: response.message));
      }
    } catch (e) {
      emit(CreateLeaveErrorState(message: e.toString()));
    }
  }
}
