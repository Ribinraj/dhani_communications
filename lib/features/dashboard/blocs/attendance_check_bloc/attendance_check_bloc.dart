import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/attendance_check_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'attendance_check_event.dart';
part 'attendance_check_state.dart';

class AttendanceCheckBloc extends Bloc<AttendanceCheckEvent, AttendanceCheckState> {
  final Apprepo repository;

  AttendanceCheckBloc({required this.repository}) : super(AttendanceCheckInitial()) {
    on<CheckAttendanceEvent>(_onCheckAttendance);
  }

  FutureOr<void> _onCheckAttendance(
    CheckAttendanceEvent event,
    Emitter<AttendanceCheckState> emit,
  ) async {
    emit(AttendanceCheckLoadingState());
    try {
      final response = await repository.checkAttendance();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(AttendanceCheckSuccessState(data: response.data!));
      } else {
        emit(AttendanceCheckErrorState(message: response.message));
      }
    } catch (e) {
      emit(AttendanceCheckErrorState(message: e.toString()));
    }
  }
}
