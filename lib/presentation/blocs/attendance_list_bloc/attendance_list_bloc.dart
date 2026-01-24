import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/attendance_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'attendance_list_event.dart';
part 'attendance_list_state.dart';

class AttendanceListBloc extends Bloc<AttendanceListEvent, AttendanceListState> {
  final Apprepo repository;

  AttendanceListBloc({required this.repository}) : super(AttendanceListInitial()) {
    on<FetchAttendanceListEvent>(_onFetchAttendanceList);
  }

  FutureOr<void> _onFetchAttendanceList(
    FetchAttendanceListEvent event,
    Emitter<AttendanceListState> emit,
  ) async {
    emit(AttendanceListLoadingState());
    try {
      final response = await repository.getAttendanceList(
        projectId: event.projectId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      if (!response.error && response.status == 200 && response.data != null) {
        emit(AttendanceListSuccessState(attendanceList: response.data!));
      } else {
        emit(AttendanceListErrorState(message: response.message));
      }
    } catch (e) {
      emit(AttendanceListErrorState(message: e.toString()));
    }
  }
}
