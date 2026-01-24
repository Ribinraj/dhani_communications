import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/leave_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
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
      final response = await repository.getLeavesList(
        projectId: event.projectId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      if (!response.error && response.status == 200 && response.data != null) {
        emit(LeaveListSuccessState(leavesList: response.data!));
      } else {
        emit(LeaveListErrorState(message: response.message));
      }
    } catch (e) {
      emit(LeaveListErrorState(message: e.toString()));
    }
  }
}
