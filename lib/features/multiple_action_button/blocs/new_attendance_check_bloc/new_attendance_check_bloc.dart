import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/attendance_check_response_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'new_attendance_check_event.dart';
part 'new_attendance_check_state.dart';

class NewAttendanceCheckBloc
    extends Bloc<NewAttendanceCheckEvent, NewAttendanceCheckState> {
  final Multiactionrepo repository;

  NewAttendanceCheckBloc({required this.repository})
    : super(NewAttendanceCheckInitial()) {
    on<CheckNewAttendanceEvent>(_onCheckAttendance);
  }

  FutureOr<void> _onCheckAttendance(
    CheckNewAttendanceEvent event,
    Emitter<NewAttendanceCheckState> emit,
  ) async {
    emit(NewAttendanceCheckLoadingState());
    try {
      final response = await repository.checkAttendance();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(NewAttendanceCheckSuccessState(data: response.data!));
      } else {
        emit(NewAttendanceCheckErrorState(message: response.message));
      }
    } catch (e) {
      emit(NewAttendanceCheckErrorState(message: e.toString()));
    }
  }
}
