import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/leave_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'leave_list_event.dart';
part 'leave_list_state.dart';

class LeaveListBloc extends Bloc<LeaveListEvent, LeaveListState> {
  final Apprepo repository;

  LeaveListBloc({required this.repository}) : super(LeaveListInitial()) {
    on<FetchLeaveListEvent>(_onFetchLeaveList);
  }

  FutureOr<void> _onFetchLeaveList(
    FetchLeaveListEvent event,
    Emitter<LeaveListState> emit,
  ) async {
    emit(LeaveListLoadingState());
    try {
      log(
        'Fetching leave list with startDate: ${event.startDate}, endDate: ${event.endDate}',
      );

      final response = await repository.getLeavesList(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (!response.error && response.status == 200 && response.data != null) {
        List<LeaveModel> filteredList = response.data!;

        // Apply client-side filtering if dates are provided
        if (event.startDate != null || event.endDate != null) {
          filteredList = _filterByDate(
            response.data!,
            event.startDate,
            event.endDate,
          );
          log('After client-side filtering: ${filteredList.length} items');
        }

        emit(LeaveListSuccessState(leavesList: filteredList));
      } else {
        emit(LeaveListErrorState(message: response.message));
      }
    } catch (e) {
      log('Error fetching leave list: $e');
      emit(LeaveListErrorState(message: e.toString()));
    }
  }

  /// Filter leave list by date range (client-side fallback)
  List<LeaveModel> _filterByDate(
    List<LeaveModel> list,
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

    return list.where((leave) {
      final leaveFromDate = DateTime.tryParse(leave.fromDate);
      final leaveToDate = DateTime.tryParse(leave.toDate);

      if (leaveFromDate == null) return true; // Keep if date can't be parsed

      // Check if leave overlaps with the filter date range
      if (start != null && leaveToDate != null && leaveToDate.isBefore(start)) {
        return false;
      }
      if (end != null && leaveFromDate.isAfter(end)) {
        return false;
      }
      return true;
    }).toList();
  }
}
