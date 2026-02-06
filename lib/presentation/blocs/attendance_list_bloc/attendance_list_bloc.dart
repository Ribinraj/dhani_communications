import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/attendance_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'attendance_list_event.dart';
part 'attendance_list_state.dart';

class AttendanceListBloc
    extends Bloc<AttendanceListEvent, AttendanceListState> {
  final Apprepo repository;

  AttendanceListBloc({required this.repository})
    : super(AttendanceListInitial()) {
    on<FetchAttendanceListEvent>(_onFetchAttendanceList);
  }

  FutureOr<void> _onFetchAttendanceList(
    FetchAttendanceListEvent event,
    Emitter<AttendanceListState> emit,
  ) async {
    emit(AttendanceListLoadingState());
    try {
      log(
        'Fetching attendance list with startDate: ${event.startDate}, endDate: ${event.endDate}',
      );

      final response = await repository.getAttendanceList(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (!response.error && response.status == 200 && response.data != null) {
        List<AttendanceModel> filteredList = response.data!;

        // Apply client-side filtering if dates are provided
        // This is a fallback in case the API doesn't filter server-side
        if (event.startDate != null || event.endDate != null) {
          filteredList = _filterByDate(
            response.data!,
            event.startDate,
            event.endDate,
          );
          log('After client-side filtering: ${filteredList.length} items');
        }

        emit(AttendanceListSuccessState(attendanceList: filteredList));
      } else {
        emit(AttendanceListErrorState(message: response.message));
      }
    } catch (e) {
      log('Error fetching attendance list: $e');
      emit(AttendanceListErrorState(message: e.toString()));
    }
  }

  /// Filter attendance list by date range (client-side fallback)
  List<AttendanceModel> _filterByDate(
    List<AttendanceModel> list,
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
      final attendanceDate = DateTime.tryParse(attendance.date);
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
