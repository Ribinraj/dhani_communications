import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/labor_attendance_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'labor_attendance_list_event.dart';
part 'labor_attendance_list_state.dart';

class LaborAttendanceListBloc
    extends Bloc<LaborAttendanceListEvent, LaborAttendanceListState> {
  final Apprepo repository;

  LaborAttendanceListBloc({required this.repository})
    : super(LaborAttendanceListInitial()) {
    on<FetchLaborAttendanceListEvent>(_onFetchLaborAttendanceList);
  }

  FutureOr<void> _onFetchLaborAttendanceList(
    FetchLaborAttendanceListEvent event,
    Emitter<LaborAttendanceListState> emit,
  ) async {
    emit(LaborAttendanceListLoadingState());
    try {
      log(
        'Fetching labor attendance list with startDate: ${event.startDate}, endDate: ${event.endDate}',
      );

      final response = await repository.getLaborAttendanceList(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (!response.error && response.status == 200 && response.data != null) {
        List<LaborAttendanceModel> filteredList = response.data!;

        // Apply client-side filtering if dates are provided
        if (event.startDate != null || event.endDate != null) {
          filteredList = _filterByDate(
            response.data!,
            event.startDate,
            event.endDate,
          );
          log('After client-side filtering: ${filteredList.length} items');
        }

        emit(
          LaborAttendanceListSuccessState(laborAttendanceList: filteredList),
        );
      } else {
        emit(LaborAttendanceListErrorState(message: response.message));
      }
    } catch (e) {
      log('Error fetching labor attendance list: $e');
      emit(LaborAttendanceListErrorState(message: e.toString()));
    }
  }

  /// Filter labor attendance list by date range (client-side fallback)
  List<LaborAttendanceModel> _filterByDate(
    List<LaborAttendanceModel> list,
    String? startDate,
    String? endDate,
  ) {
    DateTime? start;
    DateTime? end;

    if (startDate != null) {
      start = DateTime.tryParse(startDate);
    }
    if (endDate != null) {
      end = DateTime.tryParse(endDate);
      // Set end date to end of day
      if (end != null) {
        end = DateTime(end.year, end.month, end.day, 23, 59, 59);
      }
    }

    return list.where((attendance) {
      final attendanceDate = DateTime.tryParse(attendance.hireDate);
      if (attendanceDate == null) return true; // Keep if date can't be parsed

      if (start != null && attendanceDate.isBefore(start)) {
        return false;
      }
      if (end != null && attendanceDate.isAfter(end)) {
        return false;
      }
      return true;
    }).toList();
  }
}
