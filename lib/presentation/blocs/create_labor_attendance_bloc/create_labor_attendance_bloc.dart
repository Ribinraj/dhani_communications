import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'create_labor_attendance_event.dart';
part 'create_labor_attendance_state.dart';

class CreateLaborAttendanceBloc extends Bloc<CreateLaborAttendanceEvent, CreateLaborAttendanceState> {
  final Apprepo repository;

  CreateLaborAttendanceBloc({required this.repository}) : super(CreateLaborAttendanceInitial()) {
    on<SubmitLaborAttendanceEvent>(_onSubmitLaborAttendance);
  }

  FutureOr<void> _onSubmitLaborAttendance(
    SubmitLaborAttendanceEvent event,
    Emitter<CreateLaborAttendanceState> emit,
  ) async {
    emit(CreateLaborAttendanceLoadingState());
    try {
      final response = await repository.createLaborAttendance(
        projectId: event.projectId,
        laborName: event.laborName,
        laborMobile: event.laborMobile,
        laborType: event.laborType,
        attendanceDate: event.attendanceDate,
        punchInTime: event.punchInTime,
        punchInLatt: event.punchInLatt,
        punchInLong: event.punchInLong,
        userRemarks: event.userRemarks,
        picture: event.picture,
      );
      if (!response.error && response.status == 200) {
        emit(CreateLaborAttendanceSuccessState(
          laborAttendanceId: response.data,
          message: response.message,
        ));
      } else {
        emit(CreateLaborAttendanceErrorState(message: response.message));
      }
    } catch (e) {
      emit(CreateLaborAttendanceErrorState(message: e.toString()));
    }
  }
}
