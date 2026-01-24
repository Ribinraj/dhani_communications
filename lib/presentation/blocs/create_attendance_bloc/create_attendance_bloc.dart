import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'create_attendance_event.dart';
part 'create_attendance_state.dart';

class CreateAttendanceBloc extends Bloc<CreateAttendanceEvent, CreateAttendanceState> {
  final Apprepo repository;

  CreateAttendanceBloc({required this.repository}) : super(CreateAttendanceInitial()) {
    on<SubmitAttendanceEvent>(_onSubmitAttendance);
  }

  FutureOr<void> _onSubmitAttendance(
    SubmitAttendanceEvent event,
    Emitter<CreateAttendanceState> emit,
  ) async {
    emit(CreateAttendanceLoadingState());
    try {
      final response = await repository.createAttendance(
        projectId: event.projectId,
        attendance: event.attendance,
        attendanceLatt: event.attendanceLatt,
        attendanceLong: event.attendanceLong,
        userRemarks: event.userRemarks,
        picture: event.picture,
      );
      if (!response.error && response.status == 200) {
        emit(CreateAttendanceSuccessState(
          attendanceId: response.data,
          message: response.message,
        ));
      } else {
        emit(CreateAttendanceErrorState(message: response.message));
      }
    } catch (e) {
      emit(CreateAttendanceErrorState(message: e.toString()));
    }
  }
}
