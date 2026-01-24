import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/labor_attendance_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'labor_attendance_list_event.dart';
part 'labor_attendance_list_state.dart';

class LaborAttendanceListBloc extends Bloc<LaborAttendanceListEvent, LaborAttendanceListState> {
  final Apprepo repository;

  LaborAttendanceListBloc({required this.repository}) : super(LaborAttendanceListInitial()) {
    on<FetchLaborAttendanceListEvent>(_onFetchLaborAttendanceList);
  }

  FutureOr<void> _onFetchLaborAttendanceList(
    FetchLaborAttendanceListEvent event,
    Emitter<LaborAttendanceListState> emit,
  ) async {
    emit(LaborAttendanceListLoadingState());
    try {
      final response = await repository.getLaborAttendanceList(
        projectId: event.projectId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      if (!response.error && response.status == 200 && response.data != null) {
        emit(LaborAttendanceListSuccessState(laborAttendanceList: response.data!));
      } else {
        emit(LaborAttendanceListErrorState(message: response.message));
      }
    } catch (e) {
      emit(LaborAttendanceListErrorState(message: e.toString()));
    }
  }
}
