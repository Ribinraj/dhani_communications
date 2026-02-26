import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'update_labour_approvel_attendence_event.dart';
part 'update_labour_approvel_attendence_state.dart';

class UpdateLabourApprovelAttendenceBloc
    extends
        Bloc<
          UpdateLabourApprovelAttendenceEvent,
          UpdateLabourApprovelAttendenceState
        > {
  final ApprovelsRepo repository;

  UpdateLabourApprovelAttendenceBloc({required this.repository})
    : super(UpdateLabourApprovelAttendenceInitial()) {
    on<ApproveLabourAttendanceEvent>(_onApproveAttendance);
    on<RejectLabourAttendanceEvent>(_onRejectAttendance);
  }

  FutureOr<void> _onApproveAttendance(
    ApproveLabourAttendanceEvent event,
    Emitter<UpdateLabourApprovelAttendenceState> emit,
  ) async {
    emit(UpdateLabourApprovelAttendenceLoadingState());
    final response = await repository.updateLabourAttendanceApproval(
      attendanceId: event.attendanceId,
      status: 'APPROVED',
      approverRemarks: null,
    );
    if (!response.error && response.status == 200) {
      emit(
        UpdateLabourApprovelAttendenceSuccessState(message: response.message),
      );
    } else {
      emit(UpdateLabourApprovelAttendenceErrorState(message: response.message));
    }
  }

  FutureOr<void> _onRejectAttendance(
    RejectLabourAttendanceEvent event,
    Emitter<UpdateLabourApprovelAttendenceState> emit,
  ) async {
    emit(UpdateLabourApprovelAttendenceLoadingState());
    final response = await repository.updateLabourAttendanceApproval(
      attendanceId: event.attendanceId,
      status: 'REJECTED',
      approverRemarks: event.approverRemarks,
    );
    if (!response.error && response.status == 200) {
      emit(
        UpdateLabourApprovelAttendenceSuccessState(message: response.message),
      );
    } else {
      emit(UpdateLabourApprovelAttendenceErrorState(message: response.message));
    }
  }
}
